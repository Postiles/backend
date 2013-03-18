require 'test_helper'

class PostControllerTest < ActionController::TestCase
  test 'get post' do
    post :get_post, { :id => 1, :user_id => 1, :session_key => '123' }

    _post = JSON.parse(@response.body)
    assert_equal _post['status'], 'ok'
    assert_not_nil _post['message']['post']['id']
  end

  test 'new' do
    post :new, { :user_id => 1, :session_key => '123', :board_id => 1, 
        :pos_x => 1, :pos_y => 1, :span_x => 2, :span_y => 2 }

    _post = JSON.parse(@response.body)
    assert_equal _post['status'], 'ok'
    assert_not_nil _post['message']['post']['id']
  end
end
