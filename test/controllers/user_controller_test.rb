require 'test_helper'
require 'json'

class UserControllerTest < ActionDispatch::IntegrationTest
  # REGISTER
  test 'should return error response when invalid password is given' do
    register({ username: 'testing', password: 'te', password_confirmation: 'te', email: 'testing@123.com' })
    assert_response 400
    assert_equal('Error occurs!', response.parsed_body['message'])
    assert_equal(true, response.parsed_body.key?('errors'))
  end

  test 'should return error response when invalid username and password is given' do
    register({ username: 'te', password: 'te', password_confirmation: 'te', email: 'testing@123.com' })
    assert_response 400
    assert_equal('Error occurs!', response.parsed_body['message'])
    assert_equal(true, response.parsed_body.key?('errors'))
  end

  test 'should return error response when invalid username is given' do
    register({ username: 'te', password: 'testing', password_confirmation: 'testing', email: 'testing@123.com' })
    assert_response 400
    assert_equal('Error occurs!', response.parsed_body['message'])
    assert_equal(true, response.parsed_body.key?('errors'))
  end

  test 'should return error response when invalid email is given' do
    register({ username: 'testing', password: 'testing', password_confirmation: 'testing', email: 'testing' })
    assert_response 400
    assert_equal('Error occurs!', response.parsed_body['message'])
    assert_equal(true, response.parsed_body.key?('errors'))
  end

  test 'should return error response when the different password and confirmed password is given' do
    register({ username: 'testing123', password: 'testing123', password_confirmation: 'testing', email: 'testing123@example.com' })
    assert_equal 400, status
    assert_equal('Error occurs!', response.parsed_body['message'])
    assert_equal(true, response.parsed_body.key?('errors'))
  end

  test 'should return success response when valid data is given' do
    register({ username: 'testing123', password: 'testing123', password_confirmation: 'testing123', email: 'testing123@example.com' })

    assert_response :success
    assert_equal 200, status
    assert_equal('Account for "testing123" is created', response.parsed_body['message'])
    assert_equal(false, response.parsed_body.key?('errors'))
  end

  # LOGIN
  test 'should return user object and token when valid data is given' do
    register({ username: 'testing123', password: 'testing123', password_confirmation: 'testing123', email: 'testing123@example.com' })
    login({ username: 'testing123', password: 'testing123' })
    assert_response :success
    assert_equal 200, status

    user = User.select('username', 'email', 'id').find_by(username: 'testing123').to_json

    assert_equal(response.parsed_body['user'].to_json, user)
    assert_not_nil(response.parsed_body['token'])
  end

  test 'should return error object when valid data is given' do
    login({ username: 'testing12', password: 'testing123' })
    assert_response 400
    assert_equal({ 'message' => 'Invalid username or password' }, response.parsed_body)
  end

  # AUTO LOGIN
  test 'should return error message when unauthorized user is access to this endpoint' do
    register({ username: 'testing123', password: 'testing123', email: 'testing123@example.com' })
    login({ username: 'testing123', password: 'testing123' })
    get '/api/v1/user/auto_login'
    assert_equal status, 401
    assert_equal({ 'message' => 'Unauthorized' }, response.parsed_body)
  end

  test 'should return error message when token is not given by headers' do
    register({ username: 'testing123', password: 'testing123', email: 'testing123@example.com' })
    login({ username: 'testing123', password: 'testing123' })

    get '/api/v1/user/auto_login', headers: {}
    assert_equal status, 401
    assert_equal({ 'message' => 'Unauthorized' }, response.parsed_body)
  end

  test 'should return error message when invalid token is given by headers' do
    register({ username: 'testing123', password: 'testing123', email: 'testing123@example.com' })
    login({ username: 'testing123', password: 'testing123' })

    fake_token = 'asdasfsdfvsdvfd'

    get '/api/v1/user/auto_login', headers: { 'Authorization' => "Bearer #{fake_token}" }
    assert_equal status, 401
    assert_equal({ 'message' => 'Unauthorized' }, response.parsed_body)
  end

  test 'should return user object when valid token is given by headers' do
    user = User.select('username', 'email', 'id').find_by(username: 'admin').to_json

    get '/api/v1/user/auto_login', headers: { 'Authorization' => "Bearer #{token users(:admin)}" }
    assert_equal status, 200
    assert_response :success
    assert_equal response.parsed_body.to_json, user
  end
end
