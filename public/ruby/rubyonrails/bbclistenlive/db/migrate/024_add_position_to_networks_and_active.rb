class AddPositionToNetworksAndActive < ActiveRecord::Migration
  def self.up
    remove_column :networks, :position
    add_column :networks, :position, :integer, :default => 0
    add_column :networks, :active, :boolean, :default => 1
  end

  def self.down
    remove_column :networks, :active
  end
end
