class AddIsNational < ActiveRecord::Migration
  def self.up
    add_column :networks, :is_national, :boolean, :default => 1
  end

  def self.down
    remove_column :networks, :is_national
  end
end
