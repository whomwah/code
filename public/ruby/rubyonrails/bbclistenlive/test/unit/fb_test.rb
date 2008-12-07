require File.dirname(__FILE__) + '/../test_helper'
require 'flexmock/test_unit'

class FbTest < Test::Unit::TestCase
  fixtures :users

  def setup
    @fb_user = flexmock("fbuser", :session_user_id => 2820)
  end

  def test_user_id
    assert_equal Fb.user_id(@fb_user), 2820
    assert_raise(ArgumentError) { Fb.user_id }
  end
  
  def test_get_fql_query
    fb = flexmock("fql_query", :fql_query => flexmock("query", :query => nil ))
    assert data = Fb.get_fql_query(fb, "ccc")
    assert_raise(ArgumentError) { Fb.get_fql_query }
  end
  
  def test_get_friends_data
    fbf = [234234, 432423]
    flexmock(Fb).should_receive(:friends_get).and_return(fbf)
    friends = Fb.friends_get(@fb_user)
    assert_equal Array, friends.class
    assert_equal 2, friends.size
  end
  
  def test_get_user_data1
    xml = "test/unit/user2.xml"
    doc = RFacebook::Facepricot.new(open(xml))
    flexmock(Fb).should_receive(:get_fql_query).and_return(doc)
    assert !User.find_by_fbid(2820)
    assert user = Fb.get_user_data(@fb_user)
    assert_equal User, user.class
  end
  
  def test_get_user_data2
    fb_user = flexmock("fbuser", :session_user_id => 123)
    xml = "test/unit/user1.xml"
    doc = RFacebook::Facepricot.new(open(xml))
    flexmock(Fb).should_receive(:get_fql_query).and_return(doc)
    assert !User.find_by_fbid(123)
    assert user = Fb.get_user_data(fb_user)
    assert_equal User, user.class
  end
  
  def test_get_user_data3
    xml = "test/unit/user3.xml"
    doc = RFacebook::Facepricot.new(open(xml))
    flexmock(Fb).should_receive(:get_fql_query).and_return(doc)
    assert !User.find_by_fbid(507687915)
    assert user = Fb.get_user_data(@fb_user)
    assert_equal User, user.class
  end
  
  def test_get_user_data4
    fb_user = flexmock("fbuser", :session_user_id => 758625496)
    xml = "test/unit/user4.xml"
    doc = RFacebook::Facepricot.new(open(xml))
    flexmock(Fb).should_receive(:get_fql_query).and_return(doc)
    assert User.find_by_fbid(758625496)
    assert user = Fb.get_user_data(fb_user)
    assert_equal User, user.class
  end
  
  def test_get_user_data5
    fb_user = flexmock("fbuser", :session_user_id => 123)
    xml = "test/unit/user5.xml"
    doc = RFacebook::Facepricot.new(open(xml))
    flexmock(Fb).should_receive(:get_fql_query).and_return(doc)
    assert !User.find_by_fbid(666666)
    assert user = Fb.get_user_data(fb_user)
    assert_equal User, user.class
  end

	def test_get_user_data_again
		fb_user = flexmock(:session_user_id => 666)
		u = Fb.get_user_data(fb_user)
		assert_equal User, u.class
		assert_raise(RuntimeError) { Fb.get_user_data(nil) }
	end
  
  def test_set_publish_action_of_user_using
    flexmock(Fb).should_receive(:publish_data_to_feed).and_return(true)
    changes = { :new => ["new1","new2"], :old => ["old1"] }
    user = users(:duncanrobertson)
    assert Fb.set_publish_action_of_user_using(@fb_user, changes, user)
    assert !Fb.set_publish_action_of_user_using(@fb_user, "oops", user)
  end
  
  def test_build_change_list
    assert_equal Fb.send(:build_change_list, { :new => ["new1","new2"], :old => ["old1"] }), 
      "Adding <b>new1</b>, <b>new2</b> and Removing <b>old1</b>"
    assert_equal Fb.send(:build_change_list, { :new => ["new1","new2","old1"], :old => ["old1"] }), 
      "Adding <b>new1</b>, <b>new2</b>, <b>old1</b> and Removing <b>old1</b>"    
  end
end
