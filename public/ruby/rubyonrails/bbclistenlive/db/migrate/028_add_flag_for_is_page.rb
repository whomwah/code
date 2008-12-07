class AddFlagForIsPage < ActiveRecord::Migration
  def self.up
		add_column :users, :is_page, :boolean, :default => 0
  end

  def self.down
		remove_column :users, :is_page
  end
end
