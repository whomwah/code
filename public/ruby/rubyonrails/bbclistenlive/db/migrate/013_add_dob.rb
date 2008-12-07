class AddDob < ActiveRecord::Migration
  def self.up
    add_column :users, :dob, :date
  end

  def self.down
    remove_column :users, :dob
  end
end
