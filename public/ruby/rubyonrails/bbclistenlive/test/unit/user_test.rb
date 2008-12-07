require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  fixtures :networks, :users, :preferences
  
  def test_first_time
    user = users(:duncanrobertson)
    assert_equal 2, user.preferences.size
    assert !user.first_time?
    user.preferences.clear
    assert user.first_time?
  end
  
  def test_format
    user = users(:duncanrobertson)
    assert user.likes_bbc?
    assert !user.likes_windows?
    user = users(:ramlaali)
    assert user.likes_windows?
    user = users(:user_with_no_preferences)
    assert_equal nil, user.stream_type
  end
  
  def test_clicks_updater
    user = users(:duncanrobertson)
    network = networks(:BBCROne)
    old_clicks = user.preferences.find_by_network_id(network.id).clicks
    old_play_count = user.total_plays
		plays_total = Play.count
    assert_equal old_clicks + 1, user.update_clicks(network).clicks
    assert_equal old_play_count + 1, user.total_plays
    assert_equal plays_total + 1, Play.count
		assert_equal user.fbid, Play.find_by_user_id(user.id).fbid
  end
  
  def test_no_clicks_updated_within_5_mins
    user = users(:duncanrobertson)
    network = networks(:BBCROne)
    old_clicks = user.preferences.find_by_network_id(network.id).clicks
    old_play_count = user.total_plays    
    assert_equal old_clicks + 1, user.update_clicks(network).clicks
    assert_equal old_play_count + 1, user.total_plays
    assert_equal old_clicks + 1, user.update_clicks(network).clicks
    assert_equal old_play_count + 1, user.total_plays
    assert_equal old_clicks + 1, user.update_clicks(network).clicks
    assert_equal old_play_count + 1, user.total_plays
  end
  
  def test_return_the_ids_from_hash
    user = User.find(1)
    networks = { "1" => "1", "2" => "1", "3" => "0", "4" => "0", "5" => "0", "6" => "0" }
    assert_equal [1,2], user.send( :return_the_ids_from_hash, networks )
    networks = { "1" => "1", "2" => "1", "3" => "0", "4" => "1", "5" => "1", "6" => "0" }
    assert_equal [1,2,4,5], user.send( :return_the_ids_from_hash, networks )
    networks = { "1" => "0", "2" => "1", "3" => "0", "4" => "0", "5" => "0", "6" => "0" }
    assert_equal [2], user.send( :return_the_ids_from_hash, networks )
    networks = { "1" => "0", "2" => "0", "3" => "0", "4" => "0", "5" => "0", "6" => "0" }
    assert_equal [], user.send( :return_the_ids_from_hash, networks )
  end
  
  def test_adding_one_new_network
    user = users(:duncanrobertson)
    prefs = user.preferences
    cnt = prefs.size
    networks = { "1" => "1", "2" => "1", "3" => "1", "4" => "0", "5" => "0", "6" => "0" }
    assert_equal( { :new => ["BBC Radio 3"], :old => [] }, user.update_preferences(networks) )
    assert_equal cnt+1, User.find(1).networks.size
    assert_equal [0,45,0], User.find(1).preferences.map {|p| p.clicks}
  end
  
  def test_adding_two_new_networks
    user = users(:duncanrobertson)
    cnt = user.preferences.size
    networks = { "1" => "1", "2" => "1", "3" => "1", "4" => "1", "5" => "0", "6" => "0" }
    assert_equal( { :new => ["BBC Radio 3", "BBC Radio 4"], :old => [] }, user.update_preferences(networks) )
    assert_equal cnt+2, User.find(1).networks.size
    assert_equal [0,45,0,0], User.find(1).preferences.map {|p| p.clicks}
  end
  
  def test_adding_no_new_networks
    user = users(:duncanrobertson)
    cnt = user.preferences.size
    networks = { "1" => "1", "2" => "1", "3" => "0", "4" => "0", "5" => "0", "6" => "0" }
    assert_equal(  nil, user.update_preferences(networks) )
    assert_equal cnt, User.find(1).networks.size
    assert_equal [0,45], User.find(1).preferences.map {|p| p.clicks}
  end
  
  def test_removing_one_network_and_adding_one
    user = users(:duncanrobertson)
    cnt = user.preferences.size
    networks = { "1" => "0", "2" => "1", "3" => "1", "4" => "0", "5" => "0", "6" => "0" }
    assert_equal( { :new=>["BBC Radio 3"], :old=>["BBC Radio 1"] }, user.update_preferences(networks) )
    assert_equal cnt, User.find(1).networks.size
    assert_equal [45,0], User.find(1).preferences.map {|p| p.clicks}
  end
  
  def test_listens
    user = users(:duncanrobertson)
    assert_equal 45, user.total_plays
    user = users(:nickwilliams)
    assert_equal 193, user.total_plays
  end
  
  def test_update_clicks_with_no_network
    user = users(:duncanrobertson)
    network = networks(:BBCROne)
    assert_equal Preference, user.update_clicks(network).class
    assert !user.update_clicks(nil)
  end
end
