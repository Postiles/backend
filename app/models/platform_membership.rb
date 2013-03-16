class PlatformMembership < ActiveRecord::Base
  belongs_to :platform, :class_name => :Platform
  belongs_to :member, :class_name => :User

  attr_accessible :platform_id, :member_id
end
