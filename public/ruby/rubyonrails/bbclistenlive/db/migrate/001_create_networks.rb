class CreateNetworks < ActiveRecord::Migration
  BBC_NATIONAL_NETWORKS = {
    "BBCROne"   => {
      :name => "BBC Radio 1",
      :base_name => "radio1", 
      :tagline => "The best new music and entertainment"}, 
    "BBCRTwo"   => {
      :name => "BBC Radio 2",
      :base_name => "radio2", 
      :tagline => "BBC Radio 2, the most listened-to station in the UK"}, 
    "BBCRThree" => {
      :name => "BBC Radio 3",
      :base_name => "radio3", 
      :tagline => "Classical, jazz and world music, drama and arts"},
    "BBCRFour"  => {
      :name => "BBC Radio 4",
      :base_name => "radio4", 
      :tagline => "The home of intelligent speech radio"},
    "BBCRFiveL" => {
      :name => "BBC Radio Five Live",
      :base_name => "fivelive", 
      :tagline => "The home of live news and live sport"},
    "BBCRFiveX" => {
      :name => "BBC Five Live Sports Extra",
      :base_name => "fivesportsextra", 
      :tagline => "Sport commentary on Five Live's digital sister station"},
    "BBCSixMU"  => {
      :name => "BBC 6 Music",
      :base_name => "6music", 
      :tagline => "Closer to the music that matters"},
    "BBCSeven"  => {
      :name => "BBC 7",
      :base_name => "bbc7", 
      :tagline => "Unadulterated entertainment"},
    "OneXtra"   => {
      :name => "BBC 1xtra",
      :base_name => "1xtra", 
      :tagline => "The home of new black music"},
    "BBCAsian"  => {
      :name => "BBC Asian Network",
      :base_name => "asiannetwork", 
      :tagline => "British Asian music, news and entertainment"},
    "BBCWrld"   => {
      :name => "BBC World Service",
      :base_name => "worldservice", 
      :tagline => "Impartial news and reports from around the world"}
  }


  def self.up
    create_table :networks do |t|
      t.column :name, :string               # network display name
      t.column :tagline, :string            # The best new music and entertainment
      t.column :current_show, :text         # Scott and the team entertain the nation with more...
      t.column :current_title, :string      # Scott Mills
      t.column :current_start, :datetime    # "2007-01-31 16:00:28"
      t.column :current_duration, :integer  # 90 
      t.column :next_show, :text            # Join Edith for the Lunchtime Linkup, join in...
      t.column :next_title, :string         # Edith Bowman
      t.column :next_start, :datetime       # "2007-01-31 16:00:28"
      t.column :next_duration, :integer     # 90
      t.column :base_name, :string          # 6music
      t.column :channelid, :string          # BBCSixMU
      t.column :position, :integer          # sort order
    end
    
    BBC_NATIONAL_NETWORKS.each do |id, hash|
      n = Network.find_or_initialize_by_channelid(id)
      n.base_name = hash[:base_name] 
      n.name = hash[:name]
      n.tagline = hash[:tagline]
      n.save!
    end
  end

  def self.down
    drop_table :networks
  end
end
