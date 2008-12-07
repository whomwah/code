require File.dirname(__FILE__) + '/../test_helper'

class PreferenceTest < Test::Unit::TestCase
  fixtures :users, :preferences, :networks
  
  def test_plays_rank_for_all
    plays = Preference.plays_ranking
    assert_equal users(:nickwilliams), plays.first.user
    assert 3, plays.size
    assert plays.first.user.total_plays > plays.last.user.total_plays
    assert plays[0].user.total_plays > plays[1].user.total_plays
    assert_equal 193, plays.first.user.total_plays
  end

  def test_recent_plays_for_all
    plays = Preference.recent_listening
    assert_equal users(:nickwilliams), plays.first.user
    assert 3, plays.size
    assert plays.first.last_played > plays.last.last_played
    assert plays.first.network != plays.last.network
    assert_equal 193, plays.first.user.total_plays
    assert_equal 193, plays.last.user.total_plays
  end
  
  def test_recent_plays_for_users
    users = User.find(:all).collect { |u| u.fbid }
    recent_plays = Preference.recent_listening(:users => users)
    assert_equal users(:nickwilliams), recent_plays.first.user
    assert recent_plays.first.last_played > recent_plays.last.last_played
    assert_equal 193, recent_plays.first.user.total_plays
  end
  
  def test_recent_plays_for_one_user
    users = [785715547, 522101041]
    recent_listening = Preference.recent_listening(:users => users, :limit => 1)
    assert_equal 1, recent_listening.size
    assert_equal users(:ramlaali), recent_listening.first.user
  end
  
  def test_recent_listening_for_all
    recent_listening = Preference.recent_listening
    assert_equal users(:nickwilliams), recent_listening.first.user
    assert recent_listening.first.last_played > recent_listening[1].last_played
    assert_equal 193, recent_listening.first.user.total_plays
  end
  
  def test_recent_listening_for_users
    users = [785715547, 522101041]
    recent_listening = Preference.recent_listening(:users => users)
    assert_equal users(:ramlaali), recent_listening.first.user
    assert recent_listening.first.last_played > recent_listening[1].last_played
    assert_equal 3, recent_listening.first.user.total_plays
  end
  
  def test_plays_today
    assert_equal 0, Preference.plays_today
  end
  
  def test_plays_yesterday
    assert_equal 0, Preference.plays_yesterday
  end
  
  def test_played_in_last_5_mins
    p = Preference.find_by_user_id(1)
    assert !p.played_in_the_last_5_mins?

    p.last_played = Time.now
    assert p.played_in_the_last_5_mins?
  end
end
