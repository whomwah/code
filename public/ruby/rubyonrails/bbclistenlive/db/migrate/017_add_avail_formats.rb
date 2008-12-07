class AddAvailFormats < ActiveRecord::Migration
  def self.up
    add_column :networks, :ram, :string
    add_column :networks, :asx, :string
    add_column :networks, :bbc, :string
    
    Network.find(:all).each do |network|
      network.bbc = "http://www.bbc.co.uk/radio/aod/#{network.url}"
      network.save!
    end
  end

  def self.down
    remove_column :networks, :ram
    remove_column :networks, :asx
    remove_column :networks, :bbc
  end
end
