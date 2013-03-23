class UserController < ApplicationController
  def new
    # NOTE: after creating a user, must create a profile
  end

  def activate
    # NOTE: after creating a user, must create a profile
  end

  def login
    username_or_email = params[:username]

    if username_or_email.include?('@') # email given
      user = User.where(:email => username_or_email).first
    else # username given
      user = User.where(:username => username_or_email).first
    end

    unless user
      render_error CONTROLLER_ERRORS::USER_NOT_FOUND
      return
    end

    if encrypt(params[:password]) == user.password # authenticated
      user.update_attributes :session_key => gen_random_key
      render_ok :user => user
    else
      render_error CONTROLLER_ERRORS::PASSWORD_MISMATCH
    end
  end

  def logout
    user = auth(params) or return
    user.update_attributes :session_key => nil # reset session key

    render_ok
  end

  def get_user
    user = auth(params) or return
    target_user = find_user(params[:target_user_id]) or return

    render_ok :user => user, :profile => user.profile
  end

  def search_user
    search = Sunspot.search(User) do
      fulltext params[:query]
    end

    users = search.results.map do |r|
      { :user => r, :profile => r.profile }
    end

    render_ok :users => users
  end

  private
    def encrypt(password)
      return Digest::SHA1.hexdigest(password.reverse + 'mobai10000ci') # reverse, salt and SHA1
    end

    def gen_random_key
      return (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    end
end
