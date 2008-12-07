class CreatePreferences < ActiveRecord::Migration
  def self.up
    create_table :preferences do |t|
      t.column :user_id, :integer
      t.column :network_id, :integer
    end
    add_index :preferences, :user_id
    add_index :preferences, :network_id
  end

  def self.down
    drop_table :preferences
  end
end
