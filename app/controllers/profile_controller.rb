class ProfileController < ApplicationController
  def get_profile
    user = auth(params) or return
    bluelog params
    target_user = find_user(params[:target_user_id]) or return
    render_ok :profile => target_user.profile
  end
end
