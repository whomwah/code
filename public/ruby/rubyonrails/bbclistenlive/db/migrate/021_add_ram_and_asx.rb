class AddRamAndAsx < ActiveRecord::Migration
  def self.up
    n = n = Network.find_by_channelid('BBCRTwo')
    n.ram = 'http://www.bbc.co.uk/radio2/realmedia/fmg2.ram'
    n.asx = 'http://www.bbc.co.uk/radio2/wm_asx/aod/radio2.asx'
    n.save!

    n = n = Network.find_by_channelid('BBCAsian')
    n.ram = 'http://www.bbc.co.uk/asiannetwork/rams/asiann = Network.ram'
    n.asx = 'http://www.bbc.co.uk/asiannetwork/rams/asiannet_hi.asx'
    n.save!
    
    n = Network.find_by_channelid('BBCSeven')
    n.ram = 'http://www.bbc.co.uk/bbc7/realplayer/dsatg2.ram'
    n.asx = 'http://www.bbc.co.uk/bbc7/realplayer/bbc7_hi.asx'
    n.save!
    
    n = Network.find_by_channelid('BBCRFour')
    n.ram = 'http://www.bbc.co.uk/radio4/realplayer/media/fmg2.ram'
    n.asx = 'http://www.bbc.co.uk/radio4/wm_asx/aod/radio4.asx'
    n.save!
    
    n = Network.find_by_channelid('BBCWrld')
    n.ram = 'http://www.bbc.co.uk/worldservice/meta/tx/nb/live_infent_au_nb.ram'
    n.save!

    n = Network.find_by_channelid('BBCRFiveL')
    n.ram = 'http://www.bbc.co.uk/fivelive/live/surestream.ram'
    n.asx = 'http://www.bbc.co.uk/fivelive/live/live.asx'
    n.save!
    
    n = Network.find_by_channelid('BBCRThree')
    n.ram = 'http://www.bbc.co.uk/radio3/ram/r3g2.ram'
    n.asx = 'http://www.bbc.co.uk/radio3/wm_asx/aod/radio3.asx'
    n.save!
    
    n = Network.find_by_channelid('BBCRFiveX')
    n.ram = 'http://www.bbc.co.uk/fivelive/live/surestream_sportsextra.ram'
    n.asx = 'http://www.bbc.co.uk/fivelive/live/live_sportsextra.asx'
    n.save!
    
    n = Network.find_by_channelid('BBCROne')
    n.ram = 'http://www.bbc.co.uk/radio1/realaudio/media/r1live.ram'
    n.asx = 'http://www.bbc.co.uk/radio1/wm_asx/aod/radio1.asx'
    n.save!
    
    n = Network.find_by_channelid('BBCSixMU')
    n.ram = 'http://www.bbc.co.uk/6music/ram/dsatg2.ram'
    n.asx = 'http://www.bbc.co.uk/6music/ram/6music_hi.asx'
    n.save!
    
    n = Network.find_by_channelid('OneXtra')
    n.ram = 'http://www.bbc.co.uk/1xtra/realmedia/1xtralive.ram'
    n.asx = 'http://www.bbc.co.uk/1xtra/realmedia/1xtra.asx'
    n.save!
    
    ## LOCAL NETWORKS
    
    n = Network.find_by_channelid('wm')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/wm.ram'
    n.save!
    
    n = Network.find_by_channelid('scotland')
    n.ram = 'http://www.bbc.co.uk/scotland/radioscotland/media/radioscotland.ram'
    n.save!
    
    n = Network.find_by_channelid('cornwall')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/cornwall.ram'
    n.save!
    
    n = Network.find_by_channelid('berkshire')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/radioberkshire.ram'
    n.save!
    
    n = Network.find_by_channelid('three')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/threecounties.ram'
    n.save!
    
    n = Network.find_by_channelid('suffolk')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/suffolk.ram'
    n.save!
    
    n = Network.find_by_channelid('stoke')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/stoke.ram'
    n.save!
    
    n = Network.find_by_channelid('nottingham')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/nottingham.ram'
    n.save!
    
    n = Network.find_by_channelid('lincolnshire')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/lincolnshire.ram'
    n.save!
    
    n = Network.find_by_channelid('gmr')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/manchester.ram'
    n.save!
    
    n = Network.find_by_channelid('wiltshire')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/wiltshire.ram'
    n.save!
    
    n = Network.find_by_channelid('newcastle')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/newcastle.ram'
    n.save!
    
    n = Network.find_by_channelid('nangaidheal')
    n.ram = 'http://www.bbc.co.uk/scotland/alba/media/live/radio_ng.ram'
    n.save!
    
    n = Network.find_by_channelid('guernsey')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/guernsey.ram'
    n.save!
    
    n = Network.find_by_channelid('hereworc')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/herefordandworcester.ram'
    n.save!
    
    n = Network.find_by_channelid('york')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/york.ram'
    n.save!
    
    n = Network.find_by_channelid('somerset')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/somerset.ram'
    n.save!
    
    n = Network.find_by_channelid('oxford')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/radiooxford.ram'
    n.save!

    n = Network.find_by_channelid('leicester')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/leicester.ram'
    n.save!
    
    n = Network.find_by_channelid('kent')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/kent.ram'
    n.save!
    
    n = Network.find_by_channelid('cymru')
    n.ram = 'http://www.bbc.co.uk/cymru/live/rcg2.ram'
    n.save!
    
    n = Network.find_by_channelid('cleveland')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/tees.ram'
    n.save!
    
    n = Network.find_by_channelid('cambridgeshire')
    n.bbc = 'http://www.bbc.co.uk/radio/aod/cam.shtml'
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/cambridgeshire.ram'
    n.save!
    
    n = Network.find_by_channelid('wales')
    n.ram = 'http://www.bbc.co.uk/wales/live/rwg2.ram'
    n.save!
    
    n = Network.find_by_channelid('solent')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/solent.ram'
    n.save!
    
    n = Network.find_by_channelid('leeds')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/leeds.ram'
    n.save!
    
    n = Network.find_by_channelid('gloucester')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/gloucestershire.ram'
    n.save!
    
    n = Network.find_by_channelid('bristol')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/bristol.ram'
    n.save!
    
    n = Network.find_by_channelid('london')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/london.ram'
    n.save!
    
    n = Network.find_by_channelid('humberside')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/humberside.ram'
    n.save!
    
    n = Network.find_by_channelid('essex')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/essex.ram'
    n.save!
    
    n = Network.find_by_channelid('norfolk')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/norfolk.ram'
    n.save!
    
    n = Network.find_by_channelid('cumbria')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/cumbria.ram'
    n.save!
    
    n = Network.find_by_channelid('swindon')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/swindon.ram'
    n.save!
    
    n = Network.find_by_channelid('sheffield')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/sheffield.ram'
    n.save!
    
    n = Network.find_by_channelid('merseyside')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/merseyside.ram'
    n.save!
    
    n = Network.find_by_channelid('derby')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/derby.ram'
    n.save!
    
    n = Network.find_by_channelid('ulster')
    n.ram = 'http://www.bbc.co.uk/northernireland/realmedia/ru-live.ram'
    n.save!
    
    n = Network.find_by_channelid('southern')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/southerncounties.ram'
    n.save!
    
    n = Network.find_by_channelid('shropshire')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/shropshire.ram'
    n.save!
    
    n = Network.find_by_channelid('manchester')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/manchester.ram'
    n.save!
    
    n = Network.find_by_channelid('lancashire')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/lancashire.ram'
    n.save!
    
    n = Network.find_by_channelid('jersey')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/jersey.ram'
    n.save!
    
    n = Network.find_by_channelid('foyle')
    n.ram = 'http://www.bbc.co.uk/northernireland/realmedia/rf-live.ram'
    n.save!
    
    n = Network.find_by_channelid('devon')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/devon.ram'
    n.save!
    
    n = Network.find_by_channelid('northampt')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/northampton.ram'
    n.save!
    
    n = Network.find_by_channelid('covwarks')
    n.ram = 'http://www.bbc.co.uk/england/realmedia/live/localradio/coventryandwarks.ram'
    n.save!
  end

  def self.down
  end
end