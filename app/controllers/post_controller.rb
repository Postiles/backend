class PostController < ApplicationController
  def get_post
    user = auth(params) or return
    render_ok find_post(params[:id])
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

    board.posts.all.each do |p|
    end

    if post.save
      render_ok :post => post
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
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
