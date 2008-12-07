class RemoveRemainingUserData < ActiveRecord::Migration
  def self.up
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :sex
    remove_column :users, :timezone
  end

  def self.down
		# can't go back
  end
end
