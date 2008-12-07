class AddDateToPrefs < ActiveRecord::Migration
  def self.up
    add_column :preferences, :created_at, :datetime
  end

  def self.down
    remove_column :preferences, :created_at
  end
end
