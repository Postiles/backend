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
      render_ok :post => post
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
    publish board.id, PUSH_TYPE::START_EDIT, post_width_extras(post)
    
    render_ok
  end

  def submit_change
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    post.title = params[:title]
    post.content = params[:content]

    if post.save
      publish board.id, PUSH_TYPE::SUBMIT_CHANGE post_width_extras(post)
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
      publish board.id, PUSH_TYPE::TERMINATE_CHANGE post_width_extras(post)
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def like
  end

  private
    # checks whether two posts have conflict positions
    def is_two_posts_clash(post1, post2)
      not (post2.coord_x >= post1.coord_x + post1.span_x or
           post2.coord_x + post2.span_x <= post1.coord_x or
           post2.coord_y >= post1.coord_y + post1.span_y or
           post2.coord_y + post2.span_y <= post1.coord_y)
    end 
end
