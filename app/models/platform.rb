class Platform < ActiveRecord::Base
  belongs_to :creator, :class_name => :user

  has_many :platform_administratorships, :foreign_key => :platform_id
  has_many :platform_memberships, :foreign_key => :platform_id

  attr_accessible :announcement, :closed, :description, :image_small_url, :image_url, :name, :permission_type, :verified, :creator_id
end
