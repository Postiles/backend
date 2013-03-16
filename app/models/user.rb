class User < ActiveRecord::Base
  has_one :profile
  has_one :user_data

  # friendships
  has_many :pos_friendships, :class_name => :Friendship, :foreign_key => :pos_user_id
  has_many :neg_friendships, :class_name => :Friendship, :foreign_key => :neg_user_id

  attr_accessible :email, :password, :session_key, :username
end
