require 'test_helper'

class MessageControllerTest < ActionDispatch::IntegrationTest
  test 'should return message response' do
    get '/api/v1/greeting'
    assert_response :success
  end
end
