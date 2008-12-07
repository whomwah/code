require 'hpricot'
require 'rubygems'
require 'facebook_web_session'
require 'open-uri'

TVA_URL = "http://www0.rdthdo.bbc.co.uk"
TVA_API = "cgi-perl/api/query.pl?"
SHOW_LIMIT = 2
RAILS_ENV = "production"

def path_to_aod(network)
  "#{network}.shtml"
end

def profile_markup(networks_markup, user)
  <<-PROFILE
  <fb:fbml version="1.1">
  <style>
  .main h5 {
    font-size: 10px;
    padding: 0;
    margin: 0 0 2px 0;
  }
  .main p {
    font-size: 9px;
    line-height:12px;
    padding: 0;
    margin: 0;
    color: #666;
  }
  .main .play_swf {
    float: left;
  }
  .main .play_swf img {
    position:relative;
<fb:wide>
    top:5px;
</fb:wide>
  }
  .main ol {
    padding: 0;
    margin: 0;
  }
  .main ol li {
    display: block;
    list-style: none;
    margin-bottom: 6px;
  }
  .main ol li img.logo {
    float: right;
  }
  .main .meta {
    margin-left:38px;
    width:240px;
  }
  .main .meta span {
    font-size:9px;
    color:#333;
  }
  </style>

  <fb:profile-action url="#{File.join(BBC, 'radio')}">View BBC Radio</fb:profile-action>

  #{
	 %(<fb:subtitle seeallurl="http://apps.facebook.com/bbclistenlive/prefs">
    <fb:action href="">Mine</fb:action>
    <a href="http://apps.facebook.com/bbclistenlive/radio/mine" title="View my radio">Mine</a> | 
    <a href="http://apps.facebook.com/bbclistenlive/radio/friends" title="View my friends' radio">Friends</a> | 
    <a href="http://apps.facebook.com/bbclistenlive/radio/everyones" title="View everyone's radio">Everyone</a>
  </fb:subtitle>) unless user.is_page	
	}
   
  <div class="main">
    <ol>
    #{networks_markup}
    </ol>
  </div>
  </fb:fbml>
  PROFILE
end

def fetch_network_markup(networks, user)
  markup = []
	fb_page_id = "u=#{user.fbid}&" if user.is_page
  networks.each do |n|
    markup << <<-NET
  <li class="clearfix">
  <fb:narrow>
  <a href="#{n.link_to_website}"><img class="logo" src="#{File.join(APP_URL, "images", n.logo_path)}" title="#{n.name}" width="50" height="23" /></a>
  </fb:narrow>
  <fb:wide>
  <a href="#{n.link_to_website}"><img class="logo" src="#{File.join(APP_URL, "images", n.logo_path)}" title="#{n.name}" width="96" height="40" /></a>
  </fb:wide>
  <div class="play_swf">
  <fb:visible-to-owner>
  <a href="#{File.join(FBOOK_APP_URL,'radio/play')}?#{fb_page_id}n=#{n.id}" target="_blank"><img alt="Bbc" border="0" height="31" src="#{File.join(APP_URL, "images", n.path_to_media_image(user))}" width="32" /></a>
  </fb:visible-to-owner>
  </div>
  <fb:ref handle="#{n.channelid}" />
  </li>
    NET
  end
  markup
end

namespace :admin do
  desc "Re-publish all profiles. WARNING! This will take a long time!"
  task :republish_profiles => :environment do
    puts "Starting..."
    if users = User.find(:all)
      fb = RFacebook::FacebookWebSession.new(FACEBOOK["key"], FACEBOOK["secret"])
      fb.activate_with_previous_session(FB_SESSION_NON_EXIRES, FB_USER_ID)
    end
    users.each do |user|
      networks_markup = fetch_network_markup(user.networks, user)
      unless networks_markup.empty?
        markup = profile_markup(networks_markup, user)
        begin
          fb.profile_setFbml( :uid => [user.fbid], :markup => markup )
          puts "success ... User #{user.first_name} #{user.last_name} (#{user.fbid})"
        rescue Exception => e
          puts "Error, couldn't send fbid:#{user.fbid}"
        end
      end
    end
    puts "Finished..."
  end
  
  desc "Re-publish the given profile/s (ex: FBUIDS=12345,67899)"
  task :rebuild_profile => :environment do
    # assume nothing
    fbids = []
    # if ids parsed in create fb session and chop up fbids
    if ENV.include?("FBUIDS")
      fb = RFacebook::FacebookWebSession.new(FACEBOOK["key"], FACEBOOK["secret"])
      fb.activate_with_previous_session(FB_SESSION_NON_EXIRES, FB_USER_ID)
      fbids = ENV['FBUIDS'].split(',')
    end
    # loop and re-send profiles
    fbids.each do |fbid|
      next unless user = User.find_by_fbid(fbid)
      networks_markup = fetch_network_markup(user.networks, user)
      unless networks_markup.empty?
        markup = profile_markup(networks_markup, user)
        fb.profile_setFbml( :uid => [user.fbid], :markup => markup )
        puts "success ... User (#{user.fbid}) Updated"
      end
    end
  end
end
