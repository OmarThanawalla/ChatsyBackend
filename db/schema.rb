# encoding: UTF-8
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

ActiveRecord::Schema.define(:version => 20130110033608) do

  create_table "conversations", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "followers", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.integer  "follower_id",                    :null => false
    t.boolean  "Confirmed",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "followers", ["user_id", "follower_id"], :name => "FollowersProtection", :unique => true

  create_table "follows", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "follow_id",                     :null => false
    t.boolean  "Favorite",   :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "follows", ["user_id", "follow_id"], :name => "FollowProtection", :unique => true

  create_table "likes", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "message_id",                    :null => false
    t.boolean  "favors",     :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "messages", :force => true do |t|
    t.text     "message_content",                :null => false
    t.integer  "user_id",                        :null => false
    t.integer  "conversation_id",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "likes",           :default => 0
  end

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "user_conversation_mm_tables", :force => true do |t|
    t.integer  "user_id"
    t.integer  "conversation_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_conversation_mm_tables", ["user_id", "conversation_id"], :name => "noRepeats", :unique => true

  create_table "users", :force => true do |t|
    t.string   "first_name",              :limit => 25,                   :null => false
    t.string   "last_name",               :limit => 50,                   :null => false
    t.string   "email",                   :limit => 1000,                 :null => false
    t.string   "hashed_password",         :limit => 40,                   :null => false
    t.string   "Bio",                     :limit => 140,  :default => ""
    t.string   "pictureURL",                              :default => ""
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "salt",                    :limit => 225
    t.string   "encrypted_password",                      :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                           :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "userName"
    t.string   "deviceTokens",                            :default => ""
    t.string   "profilePic_file_name"
    t.string   "profilePic_content_type"
    t.integer  "profilePic_file_size"
    t.datetime "profilePic_updated_at"
  end

  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

end
