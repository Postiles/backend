class CreaterUserMailer < ActionMailer::Base
  def create_user_email(recipient)
    @subject = 'welcome on board'
      @recipients = recipient
      @from = 'postileshkust@gmail.com'
      @sent_on = Time.now
    @body["title"] = 'This is title'
      @body["email"] = 'postileshkust@gmail.com'
      @body["message"] = 'hehe'
      @headers = {}
  end
end
