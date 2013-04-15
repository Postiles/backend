Backend::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  post 'application/upload_image'

  post 'platform/new'
  post 'platform/get_platform'

  post 'topic/new'
  post 'topic/get_topic'
  post 'topic/get_topics_in_platform'

  #for testing only in current stage, no formal new board support
  post 'board/new'

  post 'board/get_board'
  post 'board/enter_board'
  post 'board/move_to'
  post 'board/get_boards_in_topic'
  post 'board/get_hotest_region'
  post 'board/get_post_count'
  post 'board/get_recent_posts'

  post 'post/new'
  post 'post/start_edit'
  post 'post/submit_change'
  post 'post/terminate_change'
  post 'post/get_post'
  post 'post/delete'
  post 'post/like'
  post 'post/unlike'

  post 'inline_comment/new'
  post 'inline_comment/get_inline_comments'
  post 'inline_comment/delete'

  post 'user/new'
  post 'user/activate'
  post 'user/login'
  post 'user/logout'
  post 'user/get_user'
  post 'user/verify_username_unique'

  post 'profile/get_profile'
  post 'profile/update_profile_item'
  post 'profile/update_profile_image'

  post 'notification/get_notifications'
  post 'notification/dismiss'
  post 'notification/dismiss_all'

  post 'search/search_topic'
  post 'search/search_board'
  post 'search/search_post'
  post 'search/search_user'
end
