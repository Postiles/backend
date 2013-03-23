class NotificationController < ApplicationController
  def get_notifications
    user = auth(params) or return
    
    notifications = user.notifications.select do |n|
      not n.read # render all the unread notifications
    end.map do |n| # map to notification with extras
      from_user = find_user(n.from_user_id)
      { 
          :notification => n, 
          :from_user => from_user,
          :from_user_profile => from_user.profile
      }
    end

    render_ok :notifications => notifications
  end

  def dismiss
    user = auth(params) or return
  end

  def dismiss_all
    
  end
end
