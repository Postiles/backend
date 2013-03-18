class ApplicationController < ActionController::Base
  protect_from_forgery

  private
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
        render_error GENERAL_ERRORS::POST_NOT_EXIST
        return nil
      end
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
      LIKE_NOT_FOUND = 'LIKE_NOT_FOUND'
      POST_POSITION_CLASH = 'POST_POSITION_CLASH'
      MEDIA_ILLEGAL = 'MEDIA_ILLEGAL'
      LINK_ILLEGAL = 'LINK_ILLEGAL'
    end
    
    module PUSH_TYPE
      START = 0
      DELETE = 1
      TERMINATE = 2
      FINISH = 3
      INLINE_COMMNET = 4
      LINK_TO = 5
    end

    module DATA_TYPE
      POST = 0
      LINK = 1
      COMMENT = 2
    end

    module NOTIFICATION_TYPE
      INLINE_COMMNET = 0
      INLINE_COMMNET_REPLY = 1
    end

end
