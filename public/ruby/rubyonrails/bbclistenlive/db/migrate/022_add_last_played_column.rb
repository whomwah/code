class AddLastPlayedColumn < ActiveRecord::Migration
  def self.up
    add_column :preferences, :last_played, :datetime
    # fill in column using the updated_at date for the time being
    Preference.update_all "last_played = updated_at WHERE clicks > 0"
    add_column :users, :total_plays , :integer, :default => 0
    # sum pref clicks for each user and store in total_plays column
    User.update_all "total_plays = (SELECT SUM(clicks) FROM preferences WHERE user_id = users.id)"
    # change format column because of name clash
    rename_column :users, :format, :stream_type
  end

  def self.down
    remove_column :preferences, :last_played
    remove_column :users, :total_plays
    rename_column :users, :stream_type, :format
  end
end
