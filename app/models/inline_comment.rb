class InlineComment < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :post

  has_many :interests, :as => :interestable

  attr_accessible :content, :post_id, :creator_id
end
