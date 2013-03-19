class Post < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :board

  has_many :inline_comments

  has_many :interests, :as => :interestable

  attr_accessible :content, :pos_x, :pos_y, :span_x, :span_y, :title, :type, :image_url, :video_link, :board_id, :creator_id

  # validations
  validates_presence_of :creator_id
  validates_presence_of :board_id

  validates_numericality_of :span_x, :greater_than => 0
  validates_numericality_of :span_y, :greater_than => 0
end
