class UserController < ApplicationController
  def new
    # NOTE: after creating a user, must create a profile
    username = params[:username]
    email = params[:email]
    password = params[:password]

    first_name = params[:first_name]
    last_name = params[:last_name]

    users = User.all

    users.each do |u|
      if u.username == username
        render_error CONTROLLER_ERRORS::USERNAME_USED
        return
      elsif u.email == email
        render_error CONTROLLER_ERRORS::EMAIL_USED
        return
      end
    end

    new_user = User.new :username => username, :email => email, :password => encrypt(password)
    new_user.profile = Profile.new :first_name => first_name, :last_name => last_name

    if new_user.save
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

=begin
  def activate
    # NOTE: after creating a user, must create a profile
  end
=end

  def login
    username_or_email = params[:username]

    if username_or_email.include?('@') # email given
      user = User.where(:email => username_or_email).first
    else # username given
      user = User.where(:username => username_or_email).first
    end

    unless user
      render_error CONTROLLER_ERRORS::PASSWORD_MISMATCH
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

    render_ok :user => target_user, :profile => target_user.profile
  end

  private
    def encrypt(password)
      return Digest::SHA1.hexdigest(password.reverse + 'mobai10000ci') # reverse, salt and SHA1
    end

    def gen_random_key
      return (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    end
end
