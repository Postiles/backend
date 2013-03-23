class SearchController < ApplicationController
  def search_topic
    
    render_ok
  end

  def search_board
    
    render_ok
  end

  def search_post

    render_ok
  end

  def search_user
    keyword = params[:keyword]

    results = User.find(:all, 
                        :include => [ :profile ],
                        :conditions => [ 
                            'username LIKE ?
                            OR email LIKE ?
                            OR Profiles.first_name LIKE ? 
                            OR Profiles.last_name LIKE ?', 
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
