class TopicMembership < ActiveRecord::Base
  belongs_to :topic, :class_name => :Topic
  belongs_to :member, :class_name => :User

  attr_accessible :topic_id, :member_id
end
