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

ActiveRecord::Schema.define(:version => 20130316082458) do

  create_table "friendships", :force => true do |t|
    t.integer  "pos_user_id",     :null => false
    t.integer  "neg_user_id",     :null => false
    t.string   "friendship_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "platforms", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "announcement"
    t.string   "permission_type"
    t.string   "image_url"
    t.string   "image_small_url"
    t.boolean  "verified"
    t.boolean  "closed"
    t.integer  "creator_id"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "profiles", :force => true do |t|
    t.string   "image_url"
    t.string   "image_small_url"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "education"
    t.string   "work"
    t.string   "location"
    t.string   "hometown"
    t.string   "signiture"
    t.string   "personal_description"
    t.string   "website"
    t.string   "language"
    t.integer  "user_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "profiles", ["user_id"], :name => "index_profiles_on_user_id"

  create_table "user_data", :force => true do |t|
    t.string   "email_confirmation_token"
    t.string   "password_forgot_confirmation_token"
    t.string   "current_ip"
    t.string   "last_sign_in_ip"
    t.integer  "sign_in_count"
    t.boolean  "email_confirmed"
    t.boolean  "got_started"
    t.boolean  "deleted"
    t.integer  "user_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "user_data", ["user_id"], :name => "index_user_data_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "email"
    t.string   "session_key"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
