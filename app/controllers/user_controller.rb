class UserController < ApplicationController
  def new
    # NOTE: after creating a user, must create a profile
    email = params[:email]
    password = params[:password]

    first_name = params[:first_name]
    last_name = params[:last_name]

    users = User.all

    users.each do |u|
      if u.email == email
        render_error CONTROLLER_ERRORS::EMAIL_USED
        return
      end
    end

    new_user = User.new :email => email, :password => encrypt(password)
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
    email = params[:username]

    if email.include?('@') # email given
      user = User.where(:email => email).first
    else # email given
      user = User.where(:email => email).first
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

  def change_password
    user = auth(params) or return
    old_password = params[:old_password]
    new_password = params[:new_password]

    if (encrypt(old_password) == user.password) # match
      if user.update_attributes :password => encrypt(new_password)
        render_ok
      else
        render_error GENERAL_ERRORS::SERVER_ERROR
      end
    else
      render_error CONTROLLER_ERRORS::PASSWORD_MISMATCH
    end
  end

  def get_user
    if params[:target_user_id ] == "0" or params[:target_user_id] == ""
      render_ok :user => "0"
      return
    end
    target_user = find_user(params[:target_user_id]) or return

    render_ok :user => target_user, :profile => target_user.profile
  end

  def get_users
    user_arr = params[:id_arr].map do |i|
      user_with_extras(find_user(i))
    end
    render_ok user_arr
  end

  def get_additional_data
    target_user = find_user(params[:target_user_id]) or return

    render_ok :additional => target_user.user_data
  end

  def finish_tutorial
    target_user = find_user(params[:target_user_id]) or return

    if target_user.user_data.update_attributes :got_started => true
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def request_invitation
    req = InvitationRequest.new :username => params[:username], 
      :email => params[:email], :reason => params[:reason]

    if req.save
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  # this route does nothing
  def this_route_does_nothing
    user = auth(params) or return

    user = User.new :email => params[:email], :password => encrypt('asdfghjkl')

    user.profile = Profile.new :username => params[:username], 
      :signiture => 'signature',
      :personal_description => 'personal description',
      :image_url => 'default_image/profile.png',
      :image_small_url => 'default_image/profile.png'

    user.user_data = UserData.new

    if user.save
      # CreaterUserMailer.create_user_email(params[:email])
      render_ok
    else
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  def get_all_grad_din_user
    render_ok GradDinUser.all
  end

  def authenticate
    user = auth(params) or return
    render_ok
  end

  def temp
  end

  private
    def encrypt(password)
      return Digest::SHA1.hexdigest(password.reverse + 'mobai10000ci') # reverse, salt and SHA1
    end

    def gen_random_key
      return (0...50).map{ ('a'..'z').to_a[rand(26)] }.join
    end
end
