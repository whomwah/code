class Preference < ActiveRecord::Base
  belongs_to :user
  belongs_to :network
  
  validates_uniqueness_of :network_id, :scope => :user_id
  
  def self.recent_listening(opts={})
    common = "clicks > 0"
    users = opts.delete(:users)
    cond  = users ? ["#{common} AND users.fbid IN (?)", users] : common
    limit = opts.delete(:limit) || 5
    find(:all, :conditions => cond, :order => "preferences.last_played DESC", 
      :joins => "INNER JOIN users ON users.id=preferences.user_id", :limit => limit)
  end
  
  def self.plays_ranking(opts={})
    common = "users.total_plays > 0"
    users = opts.delete(:users)
    cond  = users ? ["#{common} AND users.fbid IN (?)", users] : common
    limit = opts.delete(:limit) || 5
    users = User.find(:all, :include => :preferences, :conditions => cond, 
      :order => "users.total_plays DESC", :limit => limit)
    users.collect! {|u| u.preferences.find(:first, :order => "preferences.last_played DESC") }.compact
  end

  def self.plays_today
    count(:conditions => "DATE(last_played) = CURDATE()")
  end

  def self.plays_yesterday
    count(:conditions => "DATE(last_played) = ADDDATE(CURDATE(), INTERVAL -1 DAY)")
  end
  
  def played_in_the_last_5_mins?
    last_played >= (Time.now - 5.minutes) unless last_played.nil?
  end
end
