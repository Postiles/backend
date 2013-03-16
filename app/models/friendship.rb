class Friendship < ActiveRecord::Base
  belongs_to :pos_user, :class_name => :User
  belongs_to :neg_user, :class_name => :User
  attr_accessible :friendship_type, :neg_user_id, :pos_user_id
end
