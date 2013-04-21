class InlineCommentController < ApplicationController
  def new
    user = auth(params) or return
    post = find_post(params[:post_id]) or return
    board = find_board(post.board_id) or return

    comment = InlineComment.new :content => params[:content], 
        :post_id => post.id, :creator_id => user.id

    if comment.save
      data = comment_with_extras(comment)
      publish board.id, PUSH_TYPE::INLINE_COMMNET, data

      process_comment(comment)

      render_ok data
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def get_inline_comments
    post = find_post(params[:post_id]) or return

    comments = post.inline_comments.map do |ic|
      comment_with_extras(ic)
    end

    render_ok :inline_comments => comments
  end

  def delete
    user = auth(params) or return
    inline_comment = find_inline_comment(params[:comment_id]) or return

    # TODO: can only be deleted by certain users

    if inline_comment.delete # success
      publish inline_comment.post.board.id, PUSH_TYPE::DELETE_COMMENT, 
        comment_with_extras(inline_comment)
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def like
    user = auth(params) or return
    comment = find_inline_comment(params[:comment_id]) or return

    liked = Interest.where(:user_id => user.id, :interestable_id => comment.id, 
        :interestable_type => :InlineComment).first

    if liked
      render_error CONTROLLER_ERRORS::MULTIPLE_LIKE
      return
    end

    interest = comment.interests.new :liked => true, :user_id => user.id

    if interest.save
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def unlike
    user = auth(params) or return
    comment = find_inline_comment(params[:comment_id]) or return

    interest = Interest.where(:user_id => user.id, :interestable_id => comment.id, 
        :interestable_type => :InlineComment).first

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

  private

    def process_comment(comment)
      if comment.post.board.anonymous
        from_user_id = -1
      else
        from_user_id = comment.creator_id
      end

      matches = comment.content.scan(/\[at\](\d+)\[\/at\]/)

      if not matches.empty? # matches exist
        matches.each do |m|
          at_user_id = m[0].to_i
          notify :notification_type => 'mention', :read => false, :target_id => comment.post_id,
            :from_user_id => from_user_id, :user_id => at_user_id
        end
      end
      
      if comment.creator_id != comment.post.creator_id # not my own post
        # notify post creator
        notify :notification_type => 'reply in post', :read => false, :target_id => comment.post_id,
            :from_user_id => from_user_id, :user_id => comment.post.creator_id
      end

    end

end
