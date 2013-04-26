class Post < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :board

  has_many :inline_comments, :dependent => :destroy

  has_many :interests, :as => :interestable, :dependent => :destroy

  attr_accessible :content, :pos_x, :pos_y, :span_x, :span_y, :title, :type, :image_url, :video_link, :board_id, :creator_id, :in_edit

  # validations
  validates_presence_of :board_id
end
