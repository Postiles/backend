class NotificationController < ApplicationController
  def get_notifications
    user = auth(params) or return
    
    notifications = user.notifications.select do |n|
      not n.read # render all the unread notifications
    end

    render_ok :notifications => notifications
  end
end
