class Network < ActiveRecord::Base
  has_many :preferences, :dependent => :destroy
  has_many :users, :through => :preferences
  
  def formats
    formats = {}
    formats[:bbc] = bbc unless bbc.blank?
    formats[:ram] = ram unless ram.blank?
    formats[:asx] = asx unless asx.blank?
    formats
  end
  
  def total_plays
    Preference.sum('clicks', :conditions => ["network_id = ?", id])
  end
  
  def total_users
    Preference.count("network_id", :conditions => "network_id = #{id}")
  end
  
  def current_start_finish
    display_start_finish(current_start, current_duration)
  end
  
  def next_start_finish
    display_start_finish(next_start, next_duration)
  end
  
  def tagline
    read_attribute("tagline") || "No show information currently available"
  end
  
  def logo_path
    fs_path = File.join(RAILS_ROOT,"public/images/networks/#{base_name}.png")
    ht_path = "networks/#{base_name}.png"
    return ht_path if File.exists?(fs_path)
    return "networks/localradio.png"
  end
  
  def icon_path
    fs_path = File.join(RAILS_ROOT,"public/images/icons/#{base_name}.png")
    ht_path = "icons/#{base_name}.png"
    return ht_path if File.exists?(fs_path)
    return "icons/bbc.png"
  end
  
  def link_to_website
    File.join(BBC, url)
  end
  
  def link_to_audio(user, format = nil)
    format = format ? format : user.stream_type
    return asx if format == "asx" && !asx.blank?
    return ram if format == "ram" && !ram.blank?
    return bbc
  end
  
  def path_to_media_image(user)
    format = user.stream_type
    return "buttons/asx.png?1" if format == "asx" && !asx.blank?
    return "buttons/ram.png?1" if format == "ram" && !ram.blank?
    return "buttons/bbc.png?1"
  end
  
  def self.favourite(opts={})
    limit = opts.delete(:limit) || 5
    users = opts.delete(:users) || nil
    national = opts.delete(:national) || false
    
    cond = users ? ["u.fbid IN (?) AND n.is_national = ? AND n.active = 1", users, national] : ["n.is_national = ?", national]      
    Preference.find(:all, 
      :select => "p.*, COUNT(p.network_id) AS t_users", 
      :conditions => cond,
      :joins => "p INNER JOIN users u ON u.id=p.user_id " \
                  "INNER JOIN networks n ON n.id=p.network_id",
      :order => "t_users DESC", :group => "p.network_id", :limit => limit)

  end
  
  def self.popular(opts={})
    limit = opts.delete(:limit) || 5
    users = opts.delete(:users) || nil
    national = opts.delete(:national) || false

    cond = users ? ["u.fbid IN (?) AND n.is_national = ? AND n.active = 1", users, national] : ["n.is_national = ?", national]
    Preference.find(:all, 
      :select => "p.*, SUM(p.clicks) AS t_plays", 
      :conditions => cond,
      :joins => "p INNER JOIN users u ON u.id=p.user_id " \
                  "INNER JOIN networks n ON n.id=p.network_id",
      :order => "t_plays DESC", :group => "p.network_id", :limit => limit)
  end
  
  private
  
  def display_start_finish(start, duration)
    return if start.blank?
    s = start.getlocal
    f = s + duration
    "#{s.to_formatted_s(:hh_mm)}-#{f.to_formatted_s(:hh_mm)}"
  end
end
