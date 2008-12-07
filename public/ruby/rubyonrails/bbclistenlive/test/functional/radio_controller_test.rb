require File.dirname(__FILE__) + '/../test_helper'
require 'radio_controller'
require 'flexmock/test_unit'

# Re-raise errors caught by the controller.
class RadioController   
  def rescue_action(e) raise e end
  def require_facebook_login; end
end

class RadioControllerTest < Test::Unit::TestCase
  fixtures :users, :preferences, :networks

  def setup
    tmp = flexmock("fbsession", :friends_get => [758625496, 785715547])
    flexmock(RadioController).should_receive(:fbsession).and_return(tmp)
        
    @fbdata = User.find_or_create_by_fbid(522101041)
    @controller = RadioController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_yours_with_a_post
    xml = "test/unit/user1.xml"
    doc = RFacebook::Facepricot.new(open(xml))
    flexmock(Fb).should_receive(:get_fql_query).and_return(doc)
    flexmock(Fb).should_receive(:user_id).and_return(users(:duncanrobertson).fbid)
    flexmock(@controller).should_receive(:in_facebook_canvas?).and_return(true)
    post :mine
    assert_response :success
    assert assigns(:user)
    assert_equal 2, assigns(:user).networks.size
    assert_equal "19:00-00:00", assigns(:user).networks.first.current_start_finish
    assert_equal "radio1", assigns(:user).networks.first.base_name
    assert_equal "BBCROne", assigns(:user).networks.first.channelid
    assert_equal networks(:BBCROne), assigns(:user).networks.first
    assert_equal 146, networks(:BBCRTwo).total_plays
    assert_equal 45, assigns(:user).preferences.find_by_network_id(networks(:BBCRTwo).id).clicks
    assert assigns(:user).networks.find(networks(:BBCROne))
    assert_equal @fbdata.fbid, assigns(:user).networks.first.users.first.fbid
    assert_template "radio/mine"
    assert_tag :tag => "div", :attributes => { :class => "main" }
    assert_tag :tag => "h2", :child => /#{@fbdata.networks.first.current_title}/
    assert_tag :tag => "img", :attributes => { 
      :src => /http:\/\/test.host\/images\/networks\/#{@fbdata.networks.first.base_name}.png/ }
    assert_tag :tag => "div", :attributes => { :class => "main" },
      :descendant => { :tag => "ul",
        :children => { :count => 2, :only => { :tag => "li" } } }
    assert_tag :tag => "li", :attributes => { :class => "radio1" },
      :child => { :tag => "a", :attributes => { :class => "bbc" } }
    assert_tag :tag => "li", :attributes => { :class => "radio1" },
      :child => { :tag => "a", :attributes => { :class => "ram" } }
    assert_tag :tag => "li", :attributes => { :class => "radio1" },
      :child => { :tag => "a", :attributes => { :class => "asx" } }
  end
  
  def test_yours_with_a_get
    get :mine
    assert_response :error
  end
  
  def test_friends
    flexmock(Fb).should_receive(:friends_get).and_return([785715547, 758625496])
    flexmock(@controller).should_receive(:in_facebook_canvas?).and_return(true)
    post :friends
    assert_equal 2, assigns(:user_rankings).size
    assert_equal 4, assigns(:recent_listening).size
    assert_equal 1, assigns(:pop_local).size
    assert_equal 2, assigns(:fav_national).size
    assert_equal 1, assigns(:fav_local).size
    assert_response :success
    assert_template 'radio/stats'
    assert_tag :tag => "p", :attributes => { :class => "intro" }, :child => /your friends/
    assert_tag :tag => "div", :attributes => { :class => "main" }
    assert_tag :tag => "img", :attributes => { 
      :class => "score_100", 
      :src => /http:\/\/test.host\/images\/powers\/score_100.png/ }
    assert_tag :tag => "fb:user", :attributes => { :uid => "785715547" },
      :descendant => { :tag => "fb:profile-pic" }
    assert_tag :tag => "fb:user", :attributes => { :uid => "758625496" },
      :descendant => { :tag => "fb:profile-pic" }
    assert_tag :tag => "fb:user", :attributes => { :uid => "758625496" },
      :descendant => { :tag => "span", :attributes => { :class=> "last_listened" }, :child => /BBC Radio 1/ }
  end
  
  def test_everyones
    flexmock(@controller).should_receive(:in_facebook_canvas?).and_return(true)
    post :everyones
    assert_equal 4, assigns(:user_rankings).size
    assert_equal users(:nickwilliams), assigns(:user_rankings).first.user
    assert_equal users(:ramlaali), assigns(:user_rankings).last.user
    assert_equal 5, assigns(:recent_listening).size
    assert_equal users(:nickwilliams), assigns(:recent_listening).first.user
    assert_equal users(:nickwilliams), assigns(:recent_listening).last.user
    assert_equal 1, assigns(:pop_local).size
    assert_equal networks(:DuncanRadio), assigns(:pop_local).first.network
    assert_equal 2, assigns(:pop_national).size
    assert_equal networks(:BBCRTwo), assigns(:pop_national).first.network
    assert_equal 2, assigns(:fav_national).size
    assert_equal networks(:BBCRTwo), assigns(:fav_national).first.network
    assert_equal 1, assigns(:fav_local).size
    assert_equal networks(:DuncanRadio), assigns(:fav_local).first.network
    assert_tag :tag => "div", :attributes => { :class => "main" }
    assert_tag :tag => "p", :attributes => { :class => "intro" }, :child => /all facebook users/
    assert_template 'radio/stats'
    assert_tag :tag => "img", :attributes => { 
      :class => "score_100",
      :src => /http:\/\/test.host\/images\/powers\/score_100.png/ }
    assert_response :success
    assert_tag :tag => "div", :attributes => { :id => "top_listeners" },
      :descendant => { :tag => "ol",
        :children => { :count => 3, :only => { :tag => "li" } } }
    assert_tag :tag => "div", :attributes => { :id => "top_listeners" }, :descendant => { 
      :tag => "ol", :child => { :tag => "li", :child => { :tag => "fb:user",  
				:attributes => { :uid => "758625496" } } } }
  end
  
  def test_pop_up_with_no_params
    flexmock(Fb).should_receive(:user_id).and_return(users(:duncanrobertson).fbid)
    get :play
    assert !assigns(:user)
    assert !assigns(:network)
    assert_response :error
  end
  
  def test_get_pop_up_with_params_duncanrobertson
    flexmock(Fb).should_receive(:user_id).and_return(users(:duncanrobertson).fbid)
    get :play, { :n => networks(:BBCROne).id }
    assert_response :error
  end

  def test_pop_up_with_params_duncanrobertson
    flexmock(Fb).should_receive(:user_id).and_return(users(:duncanrobertson).fbid)
    cnt = users(:duncanrobertson).preferences.find_by_network_id(networks(:BBCROne).id).clicks
    post :play, { :n => networks(:BBCROne).id }
    assert assigns(:user)
    assert assigns(:network)
    assert_equal assigns(:user).preferences.find_by_network_id(assigns(:network).id).clicks, cnt + 1
    assert_tag :tag => "a", :attributes => { :href => /http:\/\/www.bbc.co.uk\/radio\/aod\/radio1/ }
    assert_response :redirect
  end
  
  def test_pop_up_with_incorrect_params
    assert_raise(ActiveRecord::RecordNotFound) {post :play, { :uid => users(:ramlaali).fbid }}
  end
  
  def test_pop_up_with_params_ramlaali
    flexmock(Fb).should_receive(:user_id).and_return(users(:ramlaali).fbid)
    cnt = users(:ramlaali).preferences.find_by_network_id(networks(:BBCRTwo).id).clicks
    post :play, { :n => networks(:BBCRTwo).id }
    assert assigns(:user)
    assert assigns(:network)
    assert_equal assigns(:user).preferences.find_by_network_id(assigns(:network).id).clicks, cnt + 1
    assert_tag :tag => "a", :attributes => { :href => /http:\/\/www.bbc.co.uk\/windows\/file/ }
    assert_response :redirect
  end
  
  def test_pop_up_with_network_not_owned
    flexmock(Fb).should_receive(:user_id).and_return(users(:ramlaali).fbid)
    post :play, { :n => networks(:BBCWrld).id }
    assert_response :success
    assert_equal 'Problem found. Please re-save your settings!', @response.body
  end

	def test_playing_a_page
		count = Play.count
    post :play, { :n => networks(:BBCRTwo).id, 
			:u => users(:page_with_two_preferences).fbid }
    assert_response :redirect
		assert_equal count + 1, Play.count
	end
end
