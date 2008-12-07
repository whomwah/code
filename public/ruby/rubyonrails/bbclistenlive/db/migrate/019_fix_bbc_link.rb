class FixBbcLink < ActiveRecord::Migration
  def self.up
    Network.find(:all).each do |network|
      network.bbc = "http://www.bbc.co.uk/radio/aod/#{network.base_name}.shtml"
      network.save!
    end
  end

  def self.down
    # no going back
  end
end
