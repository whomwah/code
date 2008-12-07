class AddPudsey < ActiveRecord::Migration
  def self.up
    Network.create(
      :position => 0,
      :url => "http://www.bbc.co.uk/pudsey/",
      :bbc => "http://www.bbc.co.uk/pudsey/games/radio_popup.shtml",
      :name => "BBC Radio Pudsey",
      :tagline => "A home for Children in Need fundraisers across the UK",
      :current_show => "BBC Children in Need's very own radio station with Sarah Cawood and Angelica Bell among the presenters. Great music, top star guests, and all the the latest from Pudsey's hard-working fundraisers around the UK",
      :current_title => "Children in Need",
      :next_show => "BBC Children in Need's very own radio station with Sarah Cawood and Angelica Bell among the presenters. Great music, top star guests, and all the the latest from Pudsey's hard-working fundraisers around the UK",
      :next_title => "Children in Need",
      :base_name => "pudsey",
      :channelid => "pudsey"
    )
  end

  def self.down
    Network.find_by_channelid("pudsey").delete
  end
end