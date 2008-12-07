class AddBengalRadio < ActiveRecord::Migration
  def self.up
    b = Network.new
    b.name = "Radio Bengali"
    b.base_name = "bengali"
    b.channelid = "bengali"
    b.is_national = 0
    b.url = "bengali"
    b.bbc = "http://www.bbc.co.uk/bengali/radio/aod/bengali_promo.shtml"
    b.save!
  end

  def self.down
    b = Network.find_by_channelid("bengali")
    b.destroy!
  end
end
