class Platform < ActiveRecord::Base
  belongs_to :creator, :class_name => :user

  has_many :topics, :dependent => :destroy

  has_many :platform_administratorships, :foreign_key => :platform_id, :dependent => :destroy
  has_many :platform_memberships, :foreign_key => :platform_id, :dependent => :destroy

  has_many :interests, :as => :interestable, :dependent => :destroy

  attr_accessible :announcement, :closed, :description, :image_small_url, :image_url, :name, :permission_type, :verified, :creator_id
end
