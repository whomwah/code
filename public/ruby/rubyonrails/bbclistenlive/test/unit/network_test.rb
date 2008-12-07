require File.dirname(__FILE__) + '/../test_helper'

class NetworkTest < Test::Unit::TestCase
  fixtures :networks, :users, :preferences

  def test_current_start_finish
    n = networks(:BBCRFiveL)
    assert_equal n.current_start_finish, "20:00-22:00"
    assert_equal n.next_start_finish, "22:00-01:00"
    n = networks(:BBCROne)
    assert_equal n.current_start_finish, "19:00-00:00"
    assert_equal n.next_start_finish, "00:00-02:00" 
    n = networks(:DuncanRadio)
    assert_equal n.next_start_finish, nil
  end
  
  def test_image_paths
    n = networks(:BBCRFiveL)
    assert_equal n.logo_path, "networks/#{n.base_name}.png"
    n = networks(:DuncanRadio)
    assert_equal n.logo_path, "networks/localradio.png"
  end
  
  def test_icon_paths
    n = networks(:BBCRFiveL)
    assert_equal n.icon_path, "icons/#{n.base_name}.png"
    n = networks(:DuncanRadio)
    assert_equal n.icon_path, "icons/bbc.png"
  end
  
  def test_taglines
    n = networks(:BBCSixMU)
    assert_equal n.tagline, "Closer to the music that matters"
    n = networks(:DuncanRadio)
    assert_equal n.tagline, "No show information currently available"
  end
  
  def test_listens_for
    n = networks(:BBCRTwo)
    assert_equal 146, n.total_plays
    assert_equal users(:duncanrobertson).networks.find(n.id).total_plays, 146
  end
  
  def test_total_users
    n = networks(:BBCRTwo)
    assert_equal 4, n.total_users
    assert_equal users(:duncanrobertson).networks.find(n.id).total_users, 4
  end
  
  def test_popular_networks
    popular = Network.popular(:national => true)
    assert_equal popular.first.network, networks(:BBCRTwo)
    assert_equal popular.last.network, networks(:BBCROne)
    assert_equal popular.first.network.total_plays, 146
    users = User.find(:all).collect{|u|u.fbid}
    popular = Network.popular(:users => users)
    assert_equal popular.first.network, networks(:DuncanRadio)
    assert_equal popular.first.network.total_plays, 5
  end
  
  def test_fav_networks
    fav = Network.favourite(:national => true)
    assert_equal fav.first.network, networks(:BBCRTwo)
    assert_equal fav.first.network.total_plays, 146
    users = User.find(:all).collect{|u|u.fbid}
    fav = Network.favourite(:users => users)
    assert_equal fav.first.network, networks(:DuncanRadio)
    assert_equal fav.first.network.total_plays, 5
    assert_equal fav.size, 1
  end
  
  def test_link_to_audio
    nick = users(:nickwilliams)
    ramla = users(:ramlaali)
    network = networks(:BBCRTwo)
    assert_equal network.link_to_audio(nick), "http://www.bbc.co.uk/radio/aod/radio2"
    assert_equal network.link_to_audio(ramla), "http://www.bbc.co.uk/windows/file"
    network = networks(:BBCRFiveL)
    assert_equal network.link_to_audio(nick), "http://www.bbc.co.uk/real/file"
    assert_equal network.link_to_audio(ramla), "http://www.bbc.co.uk/radio/aod/fivelive"
    assert_equal network.link_to_audio(ramla, nil), "http://www.bbc.co.uk/radio/aod/fivelive"
    assert_equal network.link_to_audio(ramla, ""), "http://www.bbc.co.uk/radio/aod/fivelive"
  end
  
  def test_path_to_media
    nick = users(:nickwilliams)
    ramla = users(:ramlaali)
    network = networks(:BBCRTwo)
    assert_equal network.path_to_media_image(nick), "buttons/bbc.png?1"
    assert_equal network.path_to_media_image(ramla), "buttons/asx.png?1"
    network = networks(:BBCRFiveL)
    assert_equal network.path_to_media_image(nick), "buttons/ram.png?1"
    assert_equal network.path_to_media_image(ramla), "buttons/bbc.png?1"
  end
  
  def test_link_to_website
    network = networks(:BBCRTwo)
    assert_equal "http://www.bbc.co.uk/radio2", network.link_to_website
    network = networks(:BBCRFiveX)
    assert_equal "http://www.bbc.co.uk/fivesportsextra", network.link_to_website
  end
  
  def test_formats
    n = networks(:BBCRTwo)
    assert_equal n.formats.class, Hash
    assert_equal n.formats[:ram], nil
    assert n.formats[:bbc] =~ /http:\/\/www.bbc.co.uk\/radio\/aod/
  end
end

