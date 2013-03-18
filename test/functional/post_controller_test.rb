require 'test_helper'

class PostControllerTest < ActionController::TestCase
  test 'new' do
    post :new, { :user_id => 1, :session_key => '123', :board_id => 1, 
        :pos_x => 1, :pos_y => 1, :span_x => 2, :span_y => 2 }

    data = JSON.parse(@response.body)
    assert_equal data['status'], 'ok'
  end
end
