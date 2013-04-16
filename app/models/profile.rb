class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :education, :username, :hometown, :image_small_url, :image_url, :language, :location, :personal_description, :signiture, :website, :work, :user_id

  # after_initialize :default_values

  private
    def default_values
      self.image_small_url = 'default_image/profile.png'
      self.image_url = 'default_image/profile.png'
    end
end
