class InvitationRequest < ActiveRecord::Base
  attr_accessible :email, :reason, :username
end
