class InlineCommentController < ApplicationController
  def new
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    comment = InlineComment.new :content => params[:content], 
        :post_id => post.id, :creator_id => user.id

    if comment.save
      publish board.id, PUSH_TYPE::INLINE_COMMNET, comment_width_extras(comment)
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  private

    def process_comment(comment)
    end

end
