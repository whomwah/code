class AddPlayHistoryTable < ActiveRecord::Migration
  def self.up
    create_table :plays do |t|
      t.column :user_id, :integer
			t.column :network_id, :integer
			t.column :fbid, :string
			t.column :created_at, :datetime
    end
  end

  def self.down
		drop_table :plays
  end
end
