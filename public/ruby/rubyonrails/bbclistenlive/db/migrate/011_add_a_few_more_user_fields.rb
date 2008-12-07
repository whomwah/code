class AddAFewMoreUserFields < ActiveRecord::Migration
  def self.up
    remove_column :users, :dob
    add_column :users, :birthday, :string
    add_column :users, :timezone, :string
  end

  def self.down
    remove_column :users, :birthday
    remove_column :users, :timezone
    add_column :users, :dob, :date
  end
end