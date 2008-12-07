class RemoveOldUserColumns < ActiveRecord::Migration
  def self.up
    remove_column :users, :country
    remove_column :users, :pic_small
    remove_column :users, :pic_square
    remove_column :users, :pic_big
    remove_column :users, :current_location
    remove_column :users, :dob
  end

  def self.down
  end
end
