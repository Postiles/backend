class BoardController < ApplicationController
  def new
  end

  def enter_board
    user = auth(params) or return
    board = find_board(params[:board_id]) or return

    render_ok board_with_extras(board)
  end

  # move to a region in the board and get the posts in that region
  #   @param board_id
  #   @param left, right, top, bottom
  def move_to
    user = auth(params) or return
    board = find_board(params[:board_id]) or return

    posts_to_render = [ ]

    board.posts.all.each do |p|
=begin
      if p.pos_x >= params[:left].to_i and 
          p.pos_x + p.span_x <= params[:right].to_i and
          p.pos_y >= params[:top].to_i and
          p.pos_y + p.span_y <= params[:bottom].to_i
        posts_to_render << post_with_extras(p)
      end
=end
      posts_to_render << post_with_extras(p)
    end

    render_ok :posts => posts_to_render
  end
end
