class Profile < ActiveRecord::Base
  belongs_to :user
  attr_accessible :education, :first_name, :hometown, :image_small_url, :image_url, :language, :last_name, :location, :personal_description, :signiture, :website, :work

  after_initialize :default_values

  private
    def default_values
      self.image_url = '#'
      self.image_small_url = '#'
    end
end
