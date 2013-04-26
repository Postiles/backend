class AdminMailer < ActionMailer::Base
  default :from => 'postiles.admin@postiles.com'

  def signup_request_email(email, username, reason)
    @email = email
    @username = username
    @reason = reason
    mail(:to => 'postiles.admin@postiles.com', :subject => 'New Signup Request').deliver
  end

  def report_post_abuse_email(user, post)
    @user = user
    @post = post
    
    mail(:to => 'postiles.admin@postiles.com', :subject => 'Abuse Report (Inappropriate Post)').deliver
  end

  def report_comment_abuse_email(user, comment)
    @user = user
    @comment = comment

    mail(:to => 'postiles.admin@postiles.com', :subject => 'Abuse Report (Inappropriate Comment)').deliver
  end
end
