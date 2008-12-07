require 'parsedate'

class Fb
  def self.user_id(fb)
    fb.session_user_id unless fb.blank?
  end
  
  def self.get_fql_query(fb, query)
    fb.fql_query( :query => query )
  end
  
  def self.friends_get(fb)
    fb.friends_get.uid_list
  end

	def self.is_page_admin?(fb, page)
		result = fb.pages_isAdmin( :page_id => page )
		result.at("pages_isAdmin_response").inner_html.to_i
	end

	def self.is_page_app_added?(fb, page)
		result = fb.pages_isAppAdded( :page_id => page )
		result.at("pages_isAppAdded_response").inner_html.to_i
	end
  
  def self.get_friends_without_app(fb)
    user = user_id(fb)
    q = <<-QUERY
      SELECT uid FROM user 
      WHERE has_added_app=1 and uid IN 
        (SELECT uid2 FROM friend WHERE uid1 = #{user})
    QUERY
    res = get_fql_query(fb, q)
    users = res.search("//uid").map{|xmlnode| xmlnode.inner_html}
    users
  end
  
  def self.get_user_data(fbsession, page_id = nil)
		raise if fbsession.blank?
		fbid = user_id(fbsession)
		# this must be a page
		if !page_id.nil? && is_page_admin?( fbsession, page_id )
			user = User.find_or_initialize_by_fbid( page_id )
			if user.new_record?
				user.is_page = 1
				user.save!
			end
		# this must be a user
		else
			user = User.find_or_initialize_by_fbid( fbid )
		end 
		user.stream_type = "bbc" if user.stream_type.blank?
		user 
  end
  
  def self.set_fbml_using(fb, markup, user)
    fb.profile_setFbml( :uid => [user.fbid], :markup => markup )
  end
  
  def self.set_publish_action_of_user_using(fb, changes, user)
		return if user.is_page
    if body = build_change_list(changes) 
      title = %(<fb:userlink uid="#{user.fbid}"/> has updated <fb:pronoun usethey="false" useyou="false" possessive="true" uid="#{user.fbid}" /> settings)
      publish_data_to_feed(fb, title, body)
    end
  end
  
  private
  
  def self.build_change_list(changes)
    return unless changes[:new].kind_of?(Array)
    return unless changes[:old].kind_of?(Array) 
    result = []
    added = changes[:new].collect {|n| "<b>#{n}</b>"}.join(', ')
    remov = changes[:old].collect {|o| "<b>#{o}</b>"}.join(', ')
    result << "Adding " + added unless added.blank?
    result << "Removing " + remov unless remov.blank?
    result.join(' and ')    
  end
  
  def self.publish_data_to_feed(fb, title, body)
    fb.feed_publishActionOfUser( :title => title, :body => body )
  end
end
