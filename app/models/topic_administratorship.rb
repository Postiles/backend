class TopicAdministratorship < ActiveRecord::Base
  belongs_to :topic, :class_name => :Topic
  belongs_to :administrator, :class_name => :User

  attr_accessible :topic_id, :administrator_id
end
