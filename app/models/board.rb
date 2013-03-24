class Board < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :topic

  has_many :posts, :dependent => :destroy

  has_many :board_regions, :dependent => :destroy

  has_many :channels, :dependent => :destroy

  has_many :board_administratorships, :foreign_key => :board_id, :dependent => :destroy

  has_many :interests, :as => :interestable, :dependent => :destroy

  attr_accessible :deleted, :description, :image_small_url, :image_url, :name, :topic_id, :creator_id
end
