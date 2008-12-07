# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper  
  def tab_active(str)
    'selected="true"' if params[:action] == str
  end
  
  def profile_link(user)
    content_tag('span', %(<fb:name uid="#{user.fbid}" ifcantsee="Hidden.." />), :class => 'heading')
  end
  
  def link_to_fb_user(user)
    referral_link = CGI::escape("#{FBOOK_APP_URL}?refuid=#{user.fbid}")
    "http://www.facebook.com/add.php?api_key=#{APP_APIKEY}&next=#{referral_link}"
  end
  
  def media_link(network, user, format = nil)
    result = []
    result << "#{File.join(FBOOK_APP_URL,'radio/play')}?n=#{network.id}" 
    result << "u=#{user.fbid}" if user.is_page
    result << "f=#{format}" if format
    return result.join('&')
  end
  
  def link_to_bbc_radio_site(network)
    link_to(network.name, File.join(BBC, network.url))
  end
  
  def display_pop_up_link(user, network)
    link_to(image_tag(network.path_to_media_image(user), :size => "32x31", :border => 0), 
      media_link(network, user), :target => "_blank")
  end
  
  def image_power_up(user)
    score = Integer(user.total_plays)
    if score >= 50 && score < 100
      power = "score_50"
    elsif score >= 100 && score < 200
      power = "score_100"
    elsif score >= 200 && score < 500
      power = "score_200"
    elsif score >= 500 && score < 1000
      power = "score_500"
    else
      return nil
    end
    image_tag("powers/#{power}.png", 
      :class => "#{power}", :title => pluralize(score, 'listens'))
  end
  
  def display_power_bar(user)
    
  end
end
