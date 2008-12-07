class AddFormatsToUsers < ActiveRecord::Migration
  def self.up
    remove_column :preferences, :format
    add_column :users, :format, :string, :default => "bbc"
    
    # updated preferened for all the peaple that don't have any
    last_created = Preference.find(:first, 
      :conditions => "created_at IS NOT NULL", 
      :order => "created_at ASC", :limit => 1).created_at_before_type_cast
    last_updated = Preference.find(:first, 
      :conditions => "updated_at IS NOT NULL", 
      :order => "updated_at ASC", :limit => 1).updated_at_before_type_cast
    Preference.update_all "updated_at = '#{last_updated}'", "updated_at IS NULL"
    Preference.update_all "created_at = '#{last_created}'", "created_at IS NULL"
  end

  def self.down
    add_column :preferences, :format, :string, :default => "bbc"
    remove_column :users, :format
  end
end
