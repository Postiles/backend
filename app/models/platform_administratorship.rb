class PlatformAdministratorship < ActiveRecord::Base
  belongs_to :platform, :class_name => :Platform
  belongs_to :administrator, :class_name => :User

  attr_accessible :platform_id, :administrator_id
end
