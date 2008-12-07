class UpdateUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :birthday
    add_column :users, :country, :string
  end

  def self.down
    add_column :users, :birthday, :string
    remove_column :users, :country
  end
end
