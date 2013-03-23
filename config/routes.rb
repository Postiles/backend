Backend::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  post 'post/new'
  post 'post/start_edit'
  post 'post/submit_change'
  post 'post/terminate_change'
  post 'post/get_post'
  post 'post/delete'
  post 'post/like'

  post 'inline_comment/new'
  post 'inline_comment/get_inline_comments'

  post 'board/get_board'
  post 'board/enter_board'
  post 'board/move_to'

  post 'user/new'
  post 'user/activate'
  post 'user/login'
  post 'user/logout'
  post 'user/get_user'

  post 'profile/get_profile'
end
