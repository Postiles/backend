class ApplicationController < ActionController::Base
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers

  # For all responses in this controller, return the CORS access control headers.
  def cors_set_access_control_headers
    # headers['Access-Control-Allow-Origin'] = 'http://' + request.host
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Headers'] = "Overwrite, Destination, Content-Type, Depth, User-Agent, X-File-Size, X-Requested-With, If-Modified-Since, X-File-Name, Cache-Control, Content-Length, Accept, Accept-Charset, Accept-Encoding, Referer";
  end

  def upload_image
    user = auth(params) or return

    image = params[:image]
    filename = params[:user_id] + '_' + Time.now.to_i.to_s
    
    path = "#{Rails.root}/public/uploads/#{filename}"

    File.open(path, 'wb') do |f|
      f.write(image.read)
    end

    render_ok :filename => filename
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
        message = { :channel => '/faye/' + channel.to_s, :data => { :status => status, :msg => data } }
        uri = URI.parse("http://localhost:9292/faye")
        Net::HTTP.post_form(uri, :message => message.to_json)
      end
    end

    def notify(notification_data)
      unless notification_data[:user_id] == notification_data[:from_user_id] # should not yourself notifications
        ntf = Notification.new notification_data
        if ntf.save
          publish 'notification/' + notification_data[:user_id].to_s, 
              PUSH_TYPE::NOTIFICATION, { :notification => ntf }
        end
      end
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

    def find_platform(platform_id)
      begin
        return Platform.find(platform_id)
      rescue
        render_error CONTROLLER_ERRORS::PLATFORM_NOT_FOUND
        return nil
      end
    end

    def find_topic(topic_id)
      begin
        return Topic.find(topic_id)
      rescue
        render_error CONTROLLER_ERRORS::TOPIC_NOT_FOUND
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
        render_error CONTROLLER_ERRORS::POST_NOT_FOUND
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
      return :board => board, :creator => board.creator
    end

    def post_with_extras(post)
      comments = post.inline_comments.map do |c|
        comment_with_extras(c)
      end

      return :post => post, :likes => get_likes(post), :inline_comments => comments
    end

    def comment_with_extras(comment)
      return :inline_comment => comment
    end

    def user_with_extras(user)
      return :user => user, :profile => user.profile
    end

    def get_likes(interestable)
      return interestable.interests.select do |i|
        i.liked
      end
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
      UNLIKE_ILLEGAL= 'cannot like a not liked post'
      PASSWORD_MISMATCH = 'LOGIN_FAILURE_PASSWORD_MISMATCH'
      ILLEGAL_PASSWORD = 'ILLEGAL_PSWD'
    end
    
    module PUSH_TYPE
      START = 'start'
      DELETE = 'delete'
      TERMINATE = 'terminate'
      FINISH = 'finish'
      INLINE_COMMNET = 'inline comment'
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
