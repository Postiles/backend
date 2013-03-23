class InlineCommentController < ApplicationController
  def new
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    comment = InlineComment.new :content => params[:content], 
        :post_id => post.id, :creator_id => user.id

    if comment.save
      comment_with_extras = { :inline_comment => comment, :creator => comment.creator }

      publish board.id, PUSH_TYPE::INLINE_COMMNET, comment_with_extras
      render_ok comment_with_extras
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def get_inline_comments
    user = auth(params) or return
    post = find_post(params[:post_id]) or return

    comments = post.inline_comments.map do |ic|
      { :inline_comment => ic, :creator => ic.creator }
    end

    render_ok :inline_comments => comments
  end

  private

    def process_comment(comment)
    end

end
