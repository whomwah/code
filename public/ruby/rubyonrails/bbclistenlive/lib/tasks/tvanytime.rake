require 'rubygems'
require 'facebook_web_session'
require 'open-uri'
require 'cgi'
require "rexml/document"


TVA_URL = "http://www0.rdthdo.bbc.co.uk"
TVA_API = "cgi-perl/api/query.pl?"
SHOW_LIMIT = 2
RAILS_ENV = "production"

# 01:35:12 => = (1 * (60*60)) + (35 * 60)  + 12 
def convert_duration_to_int(str)
  nos = str.split(':')
  h = Integer(nos[0]) * (60*60)
  m = Integer(nos[1]) * 60
  s = Integer(nos[2])
  h + m + s
end

def get_markup(network)
  if network.is_national
    return <<-NATIONAL
<div class="meta">
  <h5>#{CGI.escapeHTML(network.current_title)}</h5>
  <p><span class="time">#{CGI.escapeHTML(network.current_start_finish)}</span>
  <fb:wide>
    #{CGI.escapeHTML(network.current_show)}
  </fb:wide>
  </p>
</div>
    NATIONAL
  else
    return <<-LOCAL
<div class="meta">
  <h5>#{CGI.escapeHTML(network.name)}</h5>
  <p>
  <fb:wide>
    #{CGI.escapeHTML(network.tagline)}
  </fb:wide>
  </p>
</div>
    LOCAL
  end
end

namespace :tva do
  desc "Fetches now/next data from TVA schedule API and puts it in the db"
  task :schedule => :environment do
    channelids = Network.find(:all,
      :conditions => "is_national = 1 AND id != 60").collect {|n| n.channelid}
    q = [
      "method=bbc.schedule.getProgrammes", 
      "channel_id=#{channelids.join(',')}", 
      "limit=#{SHOW_LIMIT}", 
      "detail=schedule"]
    url = File.join(TVA_URL, TVA_API) + q.join('&')
    #query = "test/tv_api.xml"
    xml = open(url) { |f| f.read }
    doc = REXML::Document.new(xml)
    count = 1
    doc.elements.each("rsp/schedule/programme") do |p|
      channelid = REXML::XPath.first( p, "channel_id" ).text
      synopsis = REXML::XPath.first( p, "synopsis" ).text
      start = REXML::XPath.first( p, "start" ).text
      duration = REXML::XPath.first( p, "duration" ).text
      title = p.attributes["title"]
      network = Network.find_by_channelid(channelid)
      if count % 2 == 1
        network.current_show = synopsis
        network.current_title = title
        network.current_start = start
        network.current_duration = convert_duration_to_int(duration)
      else
        network.next_show = synopsis
        network.next_title = title
        network.next_start = start
        network.next_duration = convert_duration_to_int(duration)
      end
      network.save!
      count += 1
    end
  end
  
  desc "Sends the lastest tva data to face book via a handle for each network"
  task :sync => :schedule do
    fb = RFacebook::FacebookWebSession.new(FACEBOOK["key"], FACEBOOK["secret"])
    fb.activate_with_previous_session(FB_SESSION_NON_EXIRES, FB_USER_ID)
    Network.find(:all).each do |network|
      markup = get_markup(network)
      fb.fbml_setRefHandle( :handle => network.channelid, :fbml => markup )
    end
  end
  
  desc "Display the fbml that will be sent to facebook for each network"
  task :fbml => :schedule do
    Network.find(:all).each do |network|
      extras = "\nHandle: #{network.channelid}\n"
      markup = extras + get_markup(network)
      puts markup
    end
  end
end