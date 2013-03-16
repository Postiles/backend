class Post < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :board

  has_many :inline_comments

  has_many :interests, :as => :interestable

  attr_accessible :content, :pos_x, :pos_y, :span_x, :span_y, :title, :board_id, :creator_id
end
