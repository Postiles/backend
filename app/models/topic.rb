class Topic < ActiveRecord::Base
  belongs_to :creator, :class_name => :User
  belongs_to :platform

  has_many :boards, :dependent => :destroy

  has_many :topic_administratorships, :foreign_key => :topic_id, :dependent => :destroy
  has_many :topic_memberships, :foreign_key => :topic_id, :dependent => :destroy

  has_many :interests, :as => :interestable, :dependent => :destroy

  attr_accessible :announcement, :deleted, :description, :image_small_url, :image_url, :name, :permission_type, :platform_id, :creator_id
end
