require File.dirname(__FILE__) + '/../test_helper'
require 'prefs_controller'
require 'flexmock/test_unit'

# Re-raise errors caught by the controller.
class PrefsController
  def rescue_action(e) raise e end
  def require_facebook_login; end
end

class PrefsControllerTest < Test::Unit::TestCase
  fixtures :users, :preferences, :networks
    
  def setup
    @controller = PrefsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

	def test_attempt_to_install_page_with_being_logged_in
		assert_raise(RFacebook::FacebookSession::NotActivatedStandardError) { 
			post :index, { :fb_page_id => 7203487574 }
		}
	end

	def test_attempt_to_install_page_wrong_user_logged_in
    flexmock(Fb).should_receive(:user_id).and_return(users(:nickwilliams).fbid)
    flexmock(Fb).should_receive(:is_page_admin?).and_return(false)
		post :index, { :fb_page_id => 7203487574 }
    assert_response 200
		assert_equal assigns(:user), users(:nickwilliams)
	end

	def test_attempt_to_install_page_correct_user_logged_in
    flexmock(Fb).should_receive(:user_id).and_return(users(:nickwilliams).fbid)
    flexmock(Fb).should_receive(:is_page_admin?).and_return(true)
		post :index, { :fb_page_id => 7203487574 }
    assert_response 200
		assert_equal assigns(:user), users(:page_with_two_preferences)
	end

  def test_index_get
    get :index
    assert_response 500
  end

  def test_index_post
    fbdata = users(:duncanrobertson)
    flexmock(Fb).should_receive(:set_publish_action_of_user_using).and_return(true)
    flexmock(Fb).should_receive(:set_fbml_using).and_return(true)
    flexmock(Fb).should_receive(:user_id).and_return(fbdata.fbid)
    flexmock(Fb).should_receive(:get_user_data).and_return(fbdata)
    post :index
    assert_response :success
    assert assigns(:user)
    assert assigns(:networks)
    assert_equal networks(:BBCRTwo), assigns(:networks).first
    assert_template "prefs/index"
    assert_tag :tag => "fieldset", :attributes => { :class => "national" },
      :descendant => { :tag => "ul",
        :children => { :count => 11, :only => { :tag => "li" } } }
    assert_tag :tag => "fieldset", :attributes => { :class => "local" },
      :descendant => { :tag => "ul",
        :children => { :count => 1, :only => { :tag => "li" } } }
    assert_tag :tag => "fieldset", :attributes => { :class => "listening_formats" },
      :descendant => { :tag => "ul",
        :children => { :count => 3, :only => { :tag => "li" } } }
    assert_tag :tag => "div", :attributes => { :class => "main" }
    assigns(:networks).each do |network|
      assert_tag :tag => "h3", :attributes => { :class => "title" }, :child => /#{network.name}/
      assert_tag :tag => "p", :attributes => { :class => "tagline" }, :child => /#{network.tagline}/
      assert_tag :tag => "img", :attributes => { :class => "icon" }
    end
    assert_equal assigns(:networks).size, Network.count
    assert_no_tag :tag => "img", :attributes => { :src => /#{APP_URL}\/images\/#{fbdata.networks.first.channelid}_small.gif/ }
    assert_tag :tag => "form", :attributes => { :action => /\/bbclistenlive\/prefs\/update/ }
    assert_no_tag :tag => "fb:explanation", :attributes => { :message => /Success!/ }
    assert_no_tag :tag => "div", :attributes => { :class => "first_time" }, :child => /A little help/
    assert_tag :tag => "fieldset", :attributes => { :class => "listening_formats" }
  end
  
  def test_index_post_user_with_no_prefs
    fbdata = users(:user_with_no_preferences)
    flexmock(Fb).should_receive(:set_publish_action_of_user_using).and_return(true)
    flexmock(Fb).should_receive(:set_fbml_using).and_return(true)
    flexmock(Fb).should_receive(:user_id).and_return(fbdata.fbid)
    flexmock(Fb).should_receive(:get_user_data).and_return(fbdata)
    post :index
    assert_response :success
    assert assigns(:user)
    assert assigns(:networks)
    assert_template "prefs/index"
    assigns(:networks).each do |network|
      assert_tag :tag => "h3", :attributes => { :class => "title" }, :child => /#{network.name}/
      assert_tag :tag => "p", :attributes => { :class => "tagline" }, :child => /#{network.tagline}/
    end
    assert_equal assigns(:networks).size, Network.count
    assert fbdata.networks.empty?
    assert_tag :tag => "form", :attributes => { :action => /\/bbclistenlive\/prefs\/update/ }
    assert_no_tag :tag => "fb:explanation", :attributes => { :message => /Success!/ }
    assert_tag :tag => "div", :attributes => { :class => "first_time" }, :child => /Welcome../
    assert_tag :tag => "div", :attributes => { :class => "main" }
  end

  def test_success_post
    get :success
    assert_response 500
  end
  
  def test_success_post
    fbdata = users(:duncanrobertson)
    flexmock(Fb).should_receive(:set_publish_action_of_user_using).and_return(true)
    flexmock(Fb).should_receive(:set_fbml_using).and_return(true)
    flexmock(Fb).should_receive(:user_id).and_return(fbdata.fbid)
    flexmock(Fb).should_receive(:get_user_data).and_return(fbdata)
    post :success
    assert_response :success
    assert assigns(:user)
    assert assigns(:networks)
    assert_template "prefs/index"
    assigns(:networks).each do |network|
      assert_tag :tag => "h3", :attributes => { :class => "title" }, :child => /#{network.name}/
      assert_tag :tag => "p", :attributes => { :class => "tagline" }, :child => /#{network.tagline}/
    end
    assert_equal assigns(:networks).size, Network.count
    assert_no_tag :tag => "img", :attributes => { :src => /#{APP_URL}\/images\/#{fbdata.networks.first.channelid}_small.gif/ }
    assert_tag :tag => "form", :attributes => { :action => /\/bbclistenlive\/prefs\/update/ }
    assert_tag :tag => "fb:explanation", :attributes => { :message => /Success!/ }
    assert_tag :tag => "div", :attributes => { :class => "main" }
  end
  
  def test_update_get
    networks = {
      "1" => "1",
      "2" => "0",
      "3" => "0",
      "4" => "1",
      "5" => "1",
      "6" => "1"
    }
    user = { :stream_type => "bbc" }
    get :update, { :networks => networks, :user => user }
    assert_response 500
  end

  def test_update_posted
    duncan = users(:duncanrobertson)
    flexmock(Fb).should_receive(:set_publish_action_of_user_using).and_return(true)
    flexmock(Fb).should_receive(:set_fbml_using).and_return(true)
    flexmock(Fb).should_receive(:user_id).and_return(duncan.fbid)
    flexmock(Fb).should_receive(:get_user_data).and_return(duncan)
    networks = {
      "1" => "0",
      "2" => "1",
      "3" => "0",
      "4" => "1",
      "5" => "1",
      "6" => "1"
    }
    # user started with networks [1,2]
    user = { :stream_type => "ram" }
    assert_equal User.find(users(:duncanrobertson)).stream_type, "bbc"
    post :update, { :networks => networks, :user => user }
    assert assigns(:user)
    assert assigns(:markup)
    assert_response :success
    assert_equal User.find(assigns(:user)).networks.size, 4
    assert_equal User.find(assigns(:user)).stream_type, "ram"
    assert_tag :tag => "fb:redirect", :attributes => { :url => /#{FBOOK_APP_URL}/ }
    assert_no_tag :tag => "div", :attributes => { :class => "main" }
  end

	def test_updated_page
    page = users(:page_with_two_preferences)
    flexmock(Fb).should_receive(:set_publish_action_of_user_using).and_return(true)
    flexmock(Fb).should_receive(:set_fbml_using).and_return(true)
    flexmock(Fb).should_receive(:user_id).and_return(page.fbid)
    flexmock(Fb).should_receive(:is_page_admin?).and_return(true)
    networks = {
      "1" => "0",
      "2" => "1",
      "3" => "0",
      "4" => "1",
      "5" => "1",
      "6" => "1"
    }
    # user started with networks [1,2]
    user = { :stream_type => "ram" }
    post :update, { :networks => networks, :user => user, :fb_page_id => 7203487574 }
    assert_response :success
		assert_equal page, assigns(:user)
    assert_tag :tag => "fb:redirect", :attributes => { :url => /#{FBOOK_APP_URL}/ }
	end
  
  def test_update_posted_with_nothing_changed
    duncan = users(:duncanrobertson)
    flexmock(Fb).should_receive(:set_publish_action_of_user_using).and_return(true)
    flexmock(Fb).should_receive(:set_fbml_using).and_return(true)
    flexmock(Fb).should_receive(:user_id).and_return(duncan.fbid)
    flexmock(Fb).should_receive(:get_user_data).and_return(duncan)
    networks = { "1" => "1", "2" => "1", "3" => "0", "4" => "0", "5" => "0", "6" => "0" }
    user = { :stream_type => "ram" }
    cnt = User.find_by_fbid(duncan.fbid).networks.size
    updated = User.find_by_fbid(duncan.fbid).preferences.collect {|p| p.updated_at}
    assert_equal User.find(users(:duncanrobertson)).stream_type, "bbc"
    post :update, { :networks => networks, :user => user } 
    assert_response :success
    assert_equal User.find(assigns(:user)).networks.size, cnt
    assert_equal User.find(assigns(:user)).stream_type, "ram"
    assert_equal updated, User.find_by_fbid(duncan.fbid).preferences.collect {|p| p.updated_at}
  end
  
  def test_profile_get
    get :profile
    assert_response 500
  end
  
  def test_profile_post
    fbdata = users(:duncanrobertson)
    flexmock(Fb).should_receive(:set_publish_action_of_user_using).and_return(true)
    flexmock(Fb).should_receive(:set_fbml_using).and_return(true)
    flexmock(Fb).should_receive(:user_id).and_return(fbdata.fbid)
    flexmock(Fb).should_receive(:get_user_data).and_return(fbdata)
    post :profile
    assert_response :success
    assert assigns(:user)
    assert !assigns(:networks)
    assert_template "prefs/profile"
    assert_tag :tag => "li", :attributes => { :class => "clearfix" }
    assert_tag :tag => "div", :attributes => { :class => "main" }
    assert_tag :tag => "fb:wide", :child => { :tag => "a", 
      :child => { :tag => "img", :attributes => { :width => "96", :height => "40" } } }
    assert_tag :tag => "fb:narrow", :child => { :tag => "a", 
      :child => { :tag => "img", :attributes => { :width => "50", :height => "23" } } }
    assert_tag :tag => "fb:visible-to-owner", 
      :child => { :tag => 'a', :attributes => { 
        :href => /http:\/\/apps.facebook.com\/bbclistenlive\/radio\/play\?n\=[0-9]/,
        :target => '_blank'
        } }
  end
end
