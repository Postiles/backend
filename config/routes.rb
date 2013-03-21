Backend::Application.routes.draw do
  ActiveAdmin.routes(self)
  devise_for :admin_users, ActiveAdmin::Devise.config

  post 'post/new'
  post 'post/start_edit'
  post 'post/submit_change'
  post 'post/terminate_change'
  post 'post/get_post'
  post 'post/delete'

  post 'board/get_board'
  post 'board/enter_board'
  post 'board/move_to'

  post 'user/new'
  post 'user/activate'
  post 'user/login'
  post 'user/logout'
  post 'user/get_user'
end
