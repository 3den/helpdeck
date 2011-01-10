# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110108203657) do

  create_table "comments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "topic_id"
    t.text     "body"
    t.integer  "total_votes", :default => 0
    t.integer  "state",       :default => 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "status_id"
  end

  add_index "comments", ["state"], :name => "index_comments_on_state"
  add_index "comments", ["status_id"], :name => "index_comments_on_status_id", :unique => true
  add_index "comments", ["topic_id"], :name => "index_comments_on_topic_id"
  add_index "comments", ["total_votes"], :name => "index_comments_on_total_votes"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "topics", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.integer  "state",                         :default => 1
    t.integer  "total_votes",                   :default => 0
    t.integer  "total_views",                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "total_comments", :limit => 255, :default => 0
    t.integer  "status_id"
  end

  add_index "topics", ["state"], :name => "index_topics_on_state"
  add_index "topics", ["status_id"], :name => "index_topics_on_status_id", :unique => true
  add_index "topics", ["total_comments"], :name => "index_topics_on_total_comments"
  add_index "topics", ["total_views"], :name => "index_topics_on_total_views"
  add_index "topics", ["total_votes"], :name => "index_topics_on_total_votes"
  add_index "topics", ["user_id"], :name => "index_topics_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "secret"
    t.string   "name"
    t.string   "username"
    t.string   "image"
    t.string   "location"
    t.string   "lang",           :default => "en"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "is_admin"
    t.integer  "state",          :default => 1
    t.integer  "total_votes",    :default => 0
    t.integer  "total_topics",   :default => 0
    t.integer  "total_comments", :default => 0
  end

  add_index "users", ["is_admin"], :name => "index_users_on_is_admin"
  add_index "users", ["provider", "uid"], :name => "index_users_on_provider_and_uid", :unique => true
  add_index "users", ["secret"], :name => "index_users_on_secret"
  add_index "users", ["state"], :name => "index_users_on_state"
  add_index "users", ["token"], :name => "index_users_on_token"
  add_index "users", ["total_comments"], :name => "index_users_on_total_comments"
  add_index "users", ["total_topics"], :name => "index_users_on_total_topics"
  add_index "users", ["total_votes"], :name => "index_users_on_total_votes"
  add_index "users", ["username"], :name => "index_users_on_username"

  create_table "votes", :force => true do |t|
    t.integer  "user_id"
    t.integer  "voteable_id"
    t.string   "voteable_type"
    t.integer  "vote"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "votes", ["user_id", "voteable_type", "voteable_id"], :name => "index_votes_on_user_id_and_voteable_type_and_voteable_id", :unique => true

end
