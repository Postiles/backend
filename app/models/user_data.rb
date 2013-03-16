class UserData < ActiveRecord::Base
  belongs_to :user
  attr_accessible :current_ip, :deleted, :email_confirmation_token, :email_confirmed, :got_started, :last_sign_in_ip, :password_forgot_confirmation_token, :sign_in_count
end
