class BoardController < ApplicationController
  def new
    user = auth(params) or return
    topic = find_topic(params[topic_id]) or return

    board = Board.new :name => params[:name],
        :description => params[:description],
        :topic_id => topic.id,
        :creator_id => user.id

    if board.save
      render_ok :board => board
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def enter_board
    user = auth(params) or return
    board = find_board(params[:board_id]) or return

    render_ok :board => board, :user => user, :profile => user.profile
  end

  # move to a region in the board and get the posts in that region
  #   @param board_id
  #   @param left, right, top, bottom
  def move_to
    user = auth(params) or return
    board = find_board(params[:board_id]) or return

    posts = board.posts.map do |p|
=begin
      if p.pos_x >= params[:left].to_i and 
          p.pos_x + p.span_x <= params[:right].to_i and
          p.pos_y >= params[:top].to_i and
          p.pos_y + p.span_y <= params[:bottom].to_i
        posts_to_render << post_with_extras(p)
      end
=end
      post_with_extras(p)
    end

    render_ok :posts => posts
  end

  def get_boards_in_topic
    user = auth(params) or return
    topic = find_topic(params[:topic_id]) or return

    boards = topic.boards.map do |b|
      { :board => b, :creator => b.creator }
    end

    render_ok :boards => boards
  end
end
