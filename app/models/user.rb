class User < ActiveRecord::Base
  has_one :profile
  has_one :user_data

  # friendships
  has_many :pos_friendships, :class_name => :Friendship, :foreign_key => :pos_user_id
  has_many :neg_friendships, :class_name => :Friendship, :foreign_key => :neg_user_id

  # created
  has_many :created_platforms, :class_name => :Platform, :foreign_key => :creator_id
  has_many :created_topics, :class_name => :Topic, :foreign_key => :creator_id
  has_many :created_boards, :class_name => :Board, :foreign_key => :creator_id
  has_many :created_posts, :class_name => :Post, :foreign_key => :creator_id
  has_many :created_inline_comments, :class_name => :InlineComment, :foreign_key => :creator_id

  # administrated
  has_many :platform_administratorships, :foreign_key => :administrator_id
  has_many :topic_administratorships, :foreign_key => :administrator_id
  has_many :board_administratorships, :foreign_key => :administrator_id

  # member
  has_many :platform_memberships, :foreign_key => :member_id
  has_many :topic_memberships, :foreign_key => :member_id

  # channels
  has_many :channels

  # notifications
  has_many :notifications

  attr_accessible :email, :password, :session_key, :username
end
