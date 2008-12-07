class StoreMoreUserData < ActiveRecord::Migration
  def self.up
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :sex, :string
    add_column :users, :current_location, :string
    add_column :users, :dob, :date
    add_column :users, :pic_small, :string
    add_column :users, :pic_big, :string
    add_column :users, :pic_square, :string
  end

  def self.down
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :sex
    remove_column :users, :dob
    remove_column :users, :current_location
    remove_column :users, :pic_small
    remove_column :users, :pic_big
    remove_column :users, :pic_square
  end
end
