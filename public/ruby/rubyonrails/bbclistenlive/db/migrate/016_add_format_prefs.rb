# add format preferered of listening (RadioPlayer, WinMedia, Real)
class AddFormatPrefs < ActiveRecord::Migration
  def self.up
    add_column :preferences, :format, :string, :default => "bbc"
  end

  def self.down
    remove_column :preferences, :format
  end
end
