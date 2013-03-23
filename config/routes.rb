Backend::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  post 'application/upload_image'

  post 'platform/new'
  post 'platform/get_platform'

  post 'topic/new'
  post 'topic/get_topic'
  post 'topic/get_topics_in_platform'

  post 'board/get_board'
  post 'board/enter_board'
  post 'board/move_to'
  post 'board/get_boards_in_topic'

  post 'post/new'
  post 'post/start_edit'
  post 'post/submit_change'
  post 'post/terminate_change'
  post 'post/get_post'
  post 'post/delete'
  post 'post/like'

  post 'inline_comment/new'
  post 'inline_comment/get_inline_comments'

  post 'user/new'
  post 'user/activate'
  post 'user/login'
  post 'user/logout'
  post 'user/get_user'
  post 'user/search_user'

  post 'profile/get_profile'

  post 'notification/get_notifications'
  post 'notification/dismiss'
  post 'notification/dismiss_all'
end
