class BoardController < ApplicationController
  def new
    user = auth(params) or return
    topic = find_topic(params[:topic_id]) or return

    board = Board.new :name => params[:name],
        :description => params[:description],
        :topic_id => topic.id,
        :creator_id => user.id,
        :default_view => params[:default_view],
        :anonymous => params[:anonymous],
        :image_url => 'default_image/board.png',
        :image_small_url => 'default_image/board.png'

    if board.save
      render_ok :board => board
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def enter_board
    board = find_board(params[:board_id]) or return

    render_ok :board => board
  end

  # move to a region in the board and get the posts in that region
  #   @param board_id
  #   @param left, right, top, bottom
  def move_to
    board = find_board(params[:board_id]) or return

    currTime = Time.now

    posts = board.posts.select do |p|
      p.pos_x >= params[:left].to_i and 
        p.pos_x + p.span_x <= params[:right].to_i and
        p.pos_y >= params[:top].to_i and
        p.pos_y + p.span_y <= params[:bottom].to_i
    end.map do |p|
      # if inactive for 120 secs, mark as not in edit
      p.update_attributes :in_edit => false if currTime - p.updated_at > 120
      post_with_extras(p)
    end

    render_ok :posts => posts
  end

  def like
    user = auth(params) or return
    board = find_board(params[:board_id]) or return

    liked = Interest.where(:user_id => user.id, :interestable_id => board.id, 
        :interestable_type => :Board).first

    if liked
      render_error CONTROLLER_ERRORS::MULTIPLE_LIKE
      return
    end

    interest = board.interests.new :liked => true, :user_id => user.id

    if interest.save
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def unlike
    user = auth(params) or return
    board = find_board(params[:board_id]) or return

    interest = Interest.where(:user_id => user.id, :interestable_id => board.id, 
                              :interestable_type => :Board).first

    if !interest
      render_error CONTROLLER_ERRORS::UNLIKE_ILLEGAL
      return
    end

    if interest.delete
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def get_boards_in_topic
    topic = find_topic(params[:topic_id]) or return

    boards = topic.boards.map do |b|
      board_with_extras(b)
    end

    render_ok :boards => boards
  end

  def get_hotest_region
    board = find_board(params[:board_id]) or return

    regions = board.board_regions
  end

  def get_post_count
    board = find_board(params[:board_id]) or return

    render_ok :post_count => board.posts.length
  end

  def get_comment_count
    board = find_board(params[:board_id]) or return

    comment_count = 0

    board.posts.all.each do |p|
      comment_count += p.inline_comments.length
    end

    render_ok :comment_count => comment_count
  end

  def get_recent_posts
    board = find_board(params[:board_id]) or return

    if params[:number]
      number = params[:number].to_i
    else
      number = 2
    end

    posts_in_board = board.posts

    if posts_in_board.length < number or number == 0
      posts_to_render = posts_in_board # render all
    else
      posts_to_render = posts_in_board[ -number .. -1 ]
    end

    posts_to_render = posts_to_render.map do |p|
      post_with_extras(p)
    end

    render_ok posts_to_render
  end

  def toosimple
    user = auth(params) or return
    topic = find_topic(params[:topic_id]) or return

    board = Board.new :name => params[:name],
        :description => params[:description],
        :topic_id => topic.id,
        :creator_id => user.id,
        :default_view => params[:default_view],
        :anonymous => params[:anonymous],
        :image_url => 'default_image/board.png',
        :image_small_url => 'default_image/board.png'

    if board.save
      if params[:default_view] == 'sheet'
        GradDinUser.all.sort_by do |gdu|
          gdu.english_name
        end.each do |gdu|
          profile = Profile.where(:username => gdu.chinese_name).first
          user = profile.user

          post = Post.new
          post.title = gdu.english_name
          post.creator = user
          post.board = board
          post.save
        end
      end
      render_ok :board => board
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  private
    # find the regions that coord (row, col) belongs to
    def find_region_by_coord(board, row, col)
      row = row / 10 * 10 # top left corner of the region
      col = col / 10 * 10
      board.board_regions.where(:pos_x => col, :pos_y => row).first
    end
end
