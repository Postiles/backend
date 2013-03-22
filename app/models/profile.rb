class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :education, :first_name, :hometown, :image_small_url, :image_url, :language, :last_name, :location, :personal_description, :signiture, :website, :work, :user_id

  after_initialize :default_values

  private
    def default_values
    end
end
