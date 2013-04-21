class SearchController < ApplicationController
  def search_topic
    
    render_ok
  end

  def search_board
    
    render_ok
  end

  def search_post
    keyword = params[:keyword]

    results = Post.find(:all,
                        :conditions => [
                          'title LIKE ?
                          OR content LIKE ?',
                          "%#{keyword}%", "%#{keyword}%",
                        ])

    posts = results.map do |r|
      { :post => r }
    end

    render_ok :posts => posts
  end

  def search_comment
    keyword = params[:keyword]

    results = InlineComment.find(:all,
                                 :conditions => [
                                   'content LIKE ?',
                                   "%#{keyword}%",
                                 ])

    inline_comments = results.map do |r|
      { :inline_comment => r }
    end

    render_ok :inline_comments => inline_comments
  end

  def search_user
    keyword = params[:keyword]

    results = User.find(:all, 
                        :include => [ :profile ],
                        :conditions => [ 
                          'email LIKE ?
                          OR profiles.username LIKE ?', 
                          "%#{keyword}%", "%#{keyword}%",
                        ])

    users = results.map do |r|
      { :user => r, :profile => r.profile }
    end

    render_ok :users => users
  end

  private
    def get_sql_results(query)
      return ActiveRecord::Base.connection.execute(query)
    end
end
