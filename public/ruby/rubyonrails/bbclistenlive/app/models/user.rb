class User < ActiveRecord::Base
  has_many :preferences, :dependent => :destroy
  has_many :networks, :through => :preferences, :order => "is_national DESC"
  
  validates_uniqueness_of :fbid
  
  def likes_bbc?
    stream_type == "bbc"
  end
  
  def likes_real?
    stream_type == "ram"
  end
  
  def likes_windows?
    stream_type == "asx"
  end
  
  def first_time?
    preferences.empty?
  end
  
  def update_clicks(network)
    return unless pref = preferences.find_by_network_id(network)
    unless pref.played_in_the_last_5_mins?
      transaction do
        t = Time.now
        self.update_attributes(:total_plays => self.total_plays + 1)
        pref.update_attributes(
          :clicks => pref.clicks + 1,
          :last_played => t.utc )
				# log the play
				Play.create!(:user => self, :network => network, :fbid => fbid)
      end
    end
    pref
  end
  
  def update_preferences(new_networks)
    old_preferences = preferences.dup
    old_network_ids = networks.collect {|n| n.id}
    new_network_ids = return_the_ids_from_hash(new_networks)
    new_networks = new_network_ids - old_network_ids
    old_networks = old_network_ids - new_network_ids
    
    return nil if (new_networks + old_networks).empty?
    transaction do
      preferences.delete(preferences)
      new_network_ids.each do |network|
        clicks = 0
        network = Network.find(network)
        old_preferences.each {|p| clicks = p.clicks if p.network == network}
        preferences.create!(:network => network, :clicks => clicks)
      end
    end
    { :new => Network.find(new_networks).map {|n| n.name}, 
      :old => Network.find(old_networks).map {|n| n.name} }
  end
  
  private
  
  def return_the_ids_from_hash(hash)
    hash.blank? ? [] : hash.reject {|k,v| v == "0"}.keys.map{ |e| Integer(e) }
  end
end
