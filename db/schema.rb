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

ActiveRecord::Schema.define(:version => 20130413093314) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "board_administratorships", :force => true do |t|
    t.integer  "board_id",         :null => false
    t.integer  "administrator_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "board_regions", :force => true do |t|
    t.integer  "pos_x"
    t.integer  "pos_y"
    t.integer  "span_x"
    t.integer  "span_y"
    t.integer  "points"
    t.integer  "convolution"
    t.integer  "board_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "board_regions", ["board_id"], :name => "index_board_regions_on_board_id"

  create_table "boards", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "image_url"
    t.string   "image_small_url"
    t.boolean  "deleted"
    t.integer  "topic_id"
    t.integer  "creator_id",      :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "boards", ["topic_id"], :name => "index_boards_on_topic_id"

  create_table "channels", :force => true do |t|
    t.string   "channel_str"
    t.integer  "top_bound"
    t.integer  "bottom_bound"
    t.integer  "left_bound"
    t.integer  "right_bound"
    t.integer  "user_id"
    t.integer  "board_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "friendships", :force => true do |t|
    t.integer  "pos_user_id",     :null => false
    t.integer  "neg_user_id",     :null => false
    t.string   "friendship_type"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "inline_comments", :force => true do |t|
    t.string   "content"
    t.integer  "post_id"
    t.integer  "creator_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "inline_comments", ["post_id"], :name => "index_inline_comments_on_post_id"

  create_table "interests", :force => true do |t|
    t.boolean  "liked"
    t.boolean  "followed"
    t.integer  "user_id"
    t.integer  "interestable_id"
    t.string   "interestable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "interests", ["user_id"], :name => "index_interests_on_user_id"

  create_table "notifications", :force => true do |t|
    t.string   "notification_type"
    t.integer  "target_id"
    t.boolean  "read"
    t.integer  "from_user_id"
    t.integer  "user_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "platform_administratorships", :force => true do |t|
    t.integer  "platform_id",      :null => false
    t.integer  "administrator_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "platform_memberships", :force => true do |t|
    t.integer  "platform_id", :null => false
    t.integer  "member_id",   :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
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

  create_table "posts", :force => true do |t|
    t.string   "title"
    t.text     "content"
    t.integer  "span_x"
    t.integer  "span_y"
    t.integer  "pos_x"
    t.integer  "pos_y"
    t.integer  "board_id"
    t.integer  "creator_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "type"
    t.string   "image_url"
    t.string   "video_link"
    t.boolean  "in_edit"
  end

  add_index "posts", ["board_id"], :name => "index_posts_on_board_id"

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

  create_table "topic_administratorships", :force => true do |t|
    t.integer  "topic_id",         :null => false
    t.integer  "administrator_id", :null => false
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "topic_memberships", :force => true do |t|
    t.integer  "topic_id",   :null => false
    t.integer  "member_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "topics", :force => true do |t|
    t.string   "name"
    t.string   "description"
    t.string   "announcement"
    t.string   "image_url"
    t.string   "image_small_url"
    t.string   "permission_type"
    t.boolean  "deleted"
    t.integer  "platform_id"
    t.integer  "creator_id",      :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "topics", ["platform_id"], :name => "index_topics_on_platform_id"

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
