class Notification < ActiveRecord::Base
  belongs_to :user
  attr_accessible :notification_type, :read, :target_id, :user_id, :from_user_id
end
