class PrefsController < ApplicationController
  before_filter :require_facebook_login
  before_filter :fetch_all_networks, :except => [:profile]
  before_filter :check_for_http_post
  layout "canvas", :except => [ :profile ]
      
  def index
    @user = Fb.get_user_data(fbsession, params[:fb_page_id])
  end
  
  def success
    @user = Fb.get_user_data(fbsession, params[:fb_page_id])
    render :template => 'prefs/index'
  end

  def update
		fb_page_id = params[:fb_page_id]
    user = Fb.get_user_data(fbsession, fb_page_id)
    user.update_attributes(params[:user])
    changes = user.update_preferences(params[:networks])
    @user = User.find(user)
    @markup = fetch_profile_partial_as_string
    Fb.set_fbml_using(fbsession, @markup, user)
		if !changes.nil? and !fb_page_id
			Fb.set_publish_action_of_user_using(fbsession, changes, @user)
		end
		fb_page_id = "?fb_page_id=#{fb_page_id}" unless fb_page_id.blank?
    render :text => fb_redirect("prefs/success#{fb_page_id}")
  end
  
  def invite
    @user = User.find_by_fbid(Fb.user_id(fbsession))
    friends_without_app = Fb.get_friends_without_app(fbsession)
    @friends_list = friends_without_app.join(',')
    @invite_code = render_to_string(:template => "prefs/invite_email", :layout => false)
  end
  
  def profile
    @user = Fb.get_user_data(fbsession, params[:fb_page_id])
  end
  
  private
  
  def fetch_all_networks
    @networks = Network.find(:all, 
      :conditions => "active = 1",
      :order => "position ASC, name ASC")
  end
  
  def fetch_profile_partial_as_string
    render_to_string(:partial => "shared/profile")
  end
end
