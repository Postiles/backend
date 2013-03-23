class ProfileController < ApplicationController
  def get_profile
    user = auth(params) or return
    target_user = find_user(params[:target_user_id]) or return
    render_ok :profile => target_user.profile
  end

  def update_profile_item 
    user = auth(params) or return
    bluelog params[:item]
    if user.profile.update_attributes(params[:item] => params[:value]) # success
      render_ok
    else # fail
      render_error GENERAL_ERRORS::SERVER_ERROR
    end
  end

  private
    # checks whether the data column is not editable
    def is_profile_item_illegal(item)
      illegal_items = [ 'created_at', 'updated_at' ]
      not illegal_items.include?(item)
    end
end
