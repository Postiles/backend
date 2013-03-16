class Board < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :topic

  has_many :posts

  has_many :channels

  has_many :board_administratorships, :foreign_key => :board_id

  attr_accessible :deleted, :description, :image_small_url, :image_url, :name, :topic_id, :creator_id
end
