class CreaterUserMailer < ActionMailer::Base
  default :from => 'postiles.admin@postiles.com'

  def create_user_email(email, username, password)
    @email = email
    @username = username
    @password = password
    mail(:to => email, :subject => 'Postiles Invitation').deliver
  end
end
