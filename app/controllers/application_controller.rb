class ApplicationController < ActionController::Base
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    # headers['Access-Control-Allow-Origin'] = 'http://' + request.host
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Headers'] = "Overwrite, Destination, Content-Type, Depth, User-Agent, X-File-Size, X-Requested-With, If-Modified-Since, X-File-Name, Cache-Control, Content-Length, Accept, Accept-Charset, Accept-Encoding, Referer";
  end
  
  # If this is a preflight OPTIONS request, then short-circuit the
  # request, return only the necessary headers and return an empty
  # text/plain
  def cors_preflight_check
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = "*"
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      render :text=>'', :content_type => 'text/plain'
    end
  end

  protect_from_forgery

  private
    def publish(channel, status, data)
      Thread.new do
        PrivatePub.publish_to '/faye/' + channel, { :status => status, :data => data }
      end
    end

    def notify(notification_data)
      ntf = Notification.create notification_data
      publish '/notifications/' + notification_data[:user_id], 
          PUSH_TYPE::NOTIFICATION, { :notification => ntf }
    end

    def render_ok(message = 'ok')
      render :json => { :status => 'ok', :message => message }
    end

    def render_error(message)
      render :json => { :status => 'error', :message => message }
    end

    def auth(params)
      user_id = params[:user_id]
      session_key = params[:session_key]

      user = find_user(user_id) or return

      unless session_key and user.session_key == session_key # not authenticated
        render_error GENERAL_ERRORS::USER_NOT_LOGGED_IN
        return nil # return nothing
      end

      return user # return the user instance
    end

    def find_user(user_id)
      begin
        return User.find(user_id)
      rescue
        render_error CONTROLLER_ERRORS::USER_NOT_FOUND
        return nil
      end
    end

    def find_board(board_id)
      begin
        return Board.find(board_id)
      rescue
        render_error CONTROLLER_ERRORS::BOARD_NOT_FOUND
        return nil
      end
    end

    def find_post(post_id)
      begin
        return Post.find(post_id)
      rescue # cannot find post
        render_error GENERAL_ERRORS::POST_NOT_FOUND
        return nil
      end
    end

    def find_profile(profile_id)
      begin
        return Profile.find(profile_id)
      rescue # cannot find post
        render_error GENERAL_ERRORS::POST_NOT_FOUND
        return nil
      end
    end

    def board_with_extras(board)
      return :board => board
    end

    def post_with_extras(post)
      return :post => post, :creator => find_user(post.creator_id)
    end

    def comment_width_extras(comment)
      return :comment => comment
    end

    def user_with_extras(user)
      return :user => user, :profile => find_profile(user.profile_id)
    end

    def bluelog(msg)
      logger.debug "\033[0;34m#{msg}\033[0;30m"
    end

    module GENERAL_ERRORS
      USER_NOT_LOGGED_IN = 'USER_NOT_LOGGED_IN'
      SERVER_ERROR = 'SERVER_ERROR'
      NO_PRIVILEGE = 'NO_PRIVILEGE'
    end
 
    module CONTROLLER_ERRORS
      PLATFORM_NOT_FOUND = 'PLATFORM_NOT_FOUND'
      CHANNEL_NOT_FOUND = 'CHANNEL_NOT_FOUND'
      TOPIC_NOT_FOUND = 'TOPIC_NOT_FOUND'
      POST_NOT_FOUND = 'POST_NOT_FOUND'
      BOARD_NOT_FOUND = 'BOARD_NOT_FOUND'
      USER_NOT_FOUND = 'USER_NOT_FOUND'
      PROFILE_NOT_FOUND = 'PROFILE_NOT_FOUND'
      LIKE_NOT_FOUND = 'LIKE_NOT_FOUND'
      POST_POSITION_CLASH = 'POST_POSITION_CLASH'
      MEDIA_ILLEGAL = 'MEDIA_ILLEGAL'
      LINK_ILLEGAL = 'LINK_ILLEGAL'
      MULTIPLE_LIKE = 'multiple like'
      PASSWORD_MISMATCH = 'LOGIN_FAILURE_PASSWORD_MISMATCH'
      ILLEGAL_PASSWORD = 'ILLEGAL_PSWD'
    end
    
    module PUSH_TYPE
      START = 'start'
      DELETE = 'delete'
      TERMINATE = 'terminate'
      FINISH = 'finish'
      INLINE_COMMNET = 'inline comment'
      LINK_TO = 'link to'
      NOTIFICATION = 'notification'
    end

    module DATA_TYPE
      POST = 'post'
      LINK = 'link'
      COMMENT = 'comment'
    end

    module NOTIFICATION_TYPE
      INLINE_COMMNET = 'inline comment'
      INLINE_COMMNET_REPLY = 'comment reply'
    end

end
