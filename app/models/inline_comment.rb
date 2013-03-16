class InlineComment < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :post

  attr_accessible :content, :post_id, :creator_id
end
