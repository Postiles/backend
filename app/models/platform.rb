class Platform < ActiveRecord::Base
  belongs_to :creator, :class_name => :user
  attr_accessible :announcement, :closed, :description, :image_small_url, :image_url, :name, :permission_type, :verified, :creator_id
end
