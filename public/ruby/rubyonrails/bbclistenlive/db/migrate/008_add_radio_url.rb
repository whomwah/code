class AddRadioUrl < ActiveRecord::Migration
  def self.up
    add_column :networks, :url, :string
    networks = Network.find(:all)
    networks.each do |network|
      network.url = network.base_name
      network.save!
    end
  end

  def self.down
    remove_column :networks, :url
  end
end
