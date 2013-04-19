class NotificationController < ApplicationController
  def get_notifications
    user = auth(params) or return
    
    notifications = user.notifications.select do |n|
      not n.read # render all the unread notifications
    end.map do |n| # map to notification with extras

      if n.from_user_id == -1 # anonymous user
        from_user = nil
        from_user_profile = nil
      else
        from_user = find_user(n.from_user_id)
        from_user_profile = from_user.profile
      end

      {
          :notification => n, 
          :from_user => from_user,
          :from_user_profile => from_user_profile
      } # notice here that all notifications should be sent from some users
    end

    render_ok :notifications => notifications.reverse
  end

  def dismiss
    user = auth(params) or return

    if Notification.find(params[:notification_id]).update_attributes(:read => true)
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def dismiss_all
    user = auth(params) or return
    user.notifications.each do |n|
      n.update_attributes :read => true
    end

    render_ok
  end
end
