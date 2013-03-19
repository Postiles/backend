class Interest < ActiveRecord::Base
  belongs_to :user
  belongs_to :interestable, :polymorphic => true
  attr_accessible :followed, :liked, :user_id

  after_initialize :default_values

  private
    def default_values
      self.liked = false
      self.followed = false
    end
end
