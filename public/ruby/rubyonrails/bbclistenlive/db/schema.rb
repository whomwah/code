# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 28) do

  create_table "networks", :force => true do |t|
    t.string   "name"
    t.string   "tagline"
    t.text     "current_show"
    t.string   "current_title"
    t.datetime "current_start"
    t.integer  "current_duration"
    t.text     "next_show"
    t.string   "next_title"
    t.datetime "next_start"
    t.integer  "next_duration"
    t.string   "base_name"
    t.string   "channelid"
    t.boolean  "is_national",      :default => true
    t.string   "url"
    t.string   "ram"
    t.string   "asx"
    t.string   "bbc"
    t.integer  "position",         :default => 0
    t.boolean  "active",           :default => true
  end

  create_table "plays", :force => true do |t|
    t.integer  "user_id"
    t.integer  "network_id"
    t.string   "fbid"
    t.datetime "created_at"
  end

  create_table "preferences", :force => true do |t|
    t.integer  "user_id"
    t.integer  "network_id"
    t.integer  "clicks",      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_played"
  end

  add_index "preferences", ["user_id"], :name => "index_preferences_on_user_id"
  add_index "preferences", ["network_id"], :name => "index_preferences_on_network_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id"
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "fbid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "stream_type"
    t.integer  "total_plays", :default => 0
    t.boolean  "is_page",     :default => false
  end

end
