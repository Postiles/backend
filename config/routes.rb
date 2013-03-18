Backend::Application.routes.draw do
  post 'post/new'
  post 'post/start_edit'
  post 'post/submit_change'
  post 'post/terminate_change'
end
