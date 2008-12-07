class AddStatsForPlays < ActiveRecord::Migration
  def self.up
    add_column :preferences, :clicks, :integer, :default => 0
  end

  def self.down
    remove_column :preferences, :clicks
  end
end
