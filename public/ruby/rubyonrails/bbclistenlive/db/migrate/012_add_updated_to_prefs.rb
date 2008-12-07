class AddUpdatedToPrefs < ActiveRecord::Migration
  def self.up
    add_column :preferences, :updated_at, :datetime
  end

  def self.down
    remove_column :preferences, :updated_at
  end
end
