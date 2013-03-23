class User < ActiveRecord::Base
  has_one :profile, :dependent => :destroy
  has_one :user_data, :dependent => :destroy

  # friendships
  has_many :pos_friendships, :class_name => :Friendship, :foreign_key => :pos_user_id, :dependent => :destroy
  has_many :neg_friendships, :class_name => :Friendship, :foreign_key => :neg_user_id, :dependent => :destroy

  # created
  has_many :created_platforms, :class_name => :Platform, :foreign_key => :creator_id
  has_many :created_topics, :class_name => :Topic, :foreign_key => :creator_id
  has_many :created_boards, :class_name => :Board, :foreign_key => :creator_id
  has_many :created_posts, :class_name => :Post, :foreign_key => :creator_id
  has_many :created_inline_comments, :class_name => :InlineComment, :foreign_key => :creator_id

  # administratorships
  has_many :platform_administratorships, :foreign_key => :administrator_id, :dependent => :destroy
  has_many :topic_administratorships, :foreign_key => :administrator_id, :dependent => :destroy
  has_many :board_administratorships, :foreign_key => :administrator_id, :dependent => :destroy

  # memberships
  has_many :platform_memberships, :foreign_key => :member_id, :dependent => :destroy
  has_many :topic_memberships, :foreign_key => :member_id, :dependent => :destroy

  # channels
  has_many :channels, :dependent => :destroy

  # notifications
  has_many :notifications, :dependent => :destroy

  has_many :interests, :dependent => :destroy

  attr_accessible :email, :password, :session_key, :username

  searchable do
    text :username, :boost => 5
    text :email, :boost => 3
    text :first_name do
      profile.first_name
    end
    text :last_name do
      profile.last_name
    end
  end
end
