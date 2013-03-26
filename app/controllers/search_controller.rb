class SearchController < ApplicationController
  def search_topic
    user = auth(params) or return
    
    render_ok
  end

  def search_board
    user = auth(params) or return
    
    render_ok
  end

  def search_post
    user = auth(params) or return
    keyword = params[:keyword]

    results = Post.find(:all,
                        :conditions => [
                          'title LIKE ?
                          OR content LIKE ?',
                          "%#{keyword}%", "%#{keyword}%",
                        ])

    posts = results[0...5].map do |r| # pick 5 results
      { :post => r }
    end

    render_ok :posts => posts
  end

  def search_user
    user = auth(params) or return
    keyword = params[:keyword]

    results = User.find(:all, 
                        :include => [ :profile ],
                        :conditions => [ 
                          'username LIKE ?
                          OR email LIKE ?
                          OR profiles.first_name LIKE ? 
                          OR profiles.last_name LIKE ?', 
                          "%#{keyword}%", "%#{keyword}%", "%#{keyword}%", "%#{keyword}%",
                        ])

    users = results[0...5].map do |r| # pick 5 results
      { :user => r, :profile => r.profile }
    end

    render_ok :users => users
  end

  private
    def get_sql_results(query)
      return ActiveRecord::Base.connection.execute(query)
    end
end
