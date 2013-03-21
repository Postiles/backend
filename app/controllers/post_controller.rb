class PostController < ApplicationController
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

    # TODO: publish
    publish board.id, PUSH_TYPE::START_EDIT, post_with_extras(post)
    
    render_ok
  end

  def submit_change
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    post.title = params[:title]
    post.content = params[:content]

    if post.save
      publish board.id, PUSH_TYPE::SUBMIT_CHANGE, post_with_extras(post)
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

    interest = Interest.new :liked => true, :user_id => user.id

    if interest.save
      render_ok :interest => interest
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def delete
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    if post.delete # success
      publish board.id, PUSH_TYPE::DELETE, post_with_extras(post)
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
