module RadioHelper
  def plays_today
    p = Preference.plays_today
    content_tag('span', pluralize(p, 'person') + ' today')
  end
  
  def network_listened_last_by(preference)
    return if preference.last_played.nil?
    radio_link = link_to_bbc_radio_site(preference.network)
    last_listened = distance_of_time_in_words_to_now(preference.last_played)
    content_tag('span', "#{radio_link} .. #{last_listened} ago", :class => "last_listened")
  end
  
  def display_welcome(params)
    x = params[:action] == "everyones" ? "all facebook users" : "your friends"
    "What are #{x} listening to..."
  end
  
  def show_media_links(network, user)
    formats = network.formats
    render :partial => 'shared/media', :locals => { 
			:network => network, :formats => formats, :user => user }
  end
end
