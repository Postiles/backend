class PostController < ApplicationController
  def initialize
  end

  def new
    user = auth(params) or return
    board = find_board(params[:board_id]) or return

    post = board.posts.new(
        :pos_x => params[:pos_x], 
        :pos_y => params[:pos_y],
        :span_x => params[:span_x],
        :span_y => params[:span_y],
        :creator_id => user.id)

    # check for position conflict
    board.posts.all.each do |p|
      if is_two_posts_clash(post, p)
        post.delete
        render_error CONTROLLER_ERRORS::POST_POSITION_CLASH
        return
      end
    end

    post.image_url = params[:image_uri]
    post.video_link = params[:video_link]

    if post.save
      render_ok post_with_extras(post)
    else
      post.delete
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def start_edit
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    post.update_attributes :in_edit => true

    publish board.id, PUSH_TYPE::START, post_with_extras(post)
    
    render_ok
  end

  def submit_change
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    if post.update_attributes :title => params[:title], :content => params[:content], :in_edit => false
      publish board.id, PUSH_TYPE::FINISH, post_with_extras(post)
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def terminate_change
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    if post.delete
      publish board.id, PUSH_TYPE::TERMINATE_CHANGE, post_with_extras(post)
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def unlike
    user = auth(params) or return
    post = find_post(params[:post_id]) or return;
    board = find_board(post.board_id) or return;
    interest = Interest.where(:user_id => user.id, :interestable_id => post.id, 
                              :interestable_type => :Post).first

    if !interest
      render_error CONTROLLER_ERRORS::UNLIKE_ILLEGAL
    end

    if interest.delete
      # notify :notification_type => 'unlike post', :read => false, :target_id => post.id,
      #   :from_user_id => user.id, :user_id => post.creator_id
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def like
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    # check whether the user already liked the post
    liked = Interest.where(:user_id => user.id, :interestable_id => post.id, 
        :interestable_type => :Post).first
    
    if liked # already liked this post
      render_error CONTROLLER_ERRORS::MULTIPLE_LIKE
      return
    end

    if params[:unlike] # cancel like
      if interest.delete
        render_error GENERAL_ERRORS::SERVER_ERROR
        return
      end
    end

    interest = post.interests.new :liked => true, :user_id => user.id

    if interest.save
      notify :notification_type => 'like post', :read => false, :target_id => post.id,
          :from_user_id => user.id, :user_id => post.creator_id # notify the post creator
      render_ok :interest => interest
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def delete
    user = auth(params) or return
    post = find_post(params[:post_id]) or return

    # TODO: can only be deleted by certain users

    if post.delete # success
      publish post.board.id, PUSH_TYPE::DELETE, post_with_extras(post)
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def get_post
    user = auth(params) or return
    post = find_post(params[:post_id]) or return

    render_ok post_with_extras(post)
  end

  private
    # checks whether two posts have conflict positions
    def is_two_posts_clash(post1, post2)
      not (post2.pos_x >= post1.pos_x + post1.span_x or
           post2.pos_x + post2.span_x <= post1.pos_x or
           post2.pos_y >= post1.pos_y + post1.span_y or
           post2.pos_y + post2.span_y <= post1.pos_y)
    end 
end
