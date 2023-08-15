require "test_helper"

class PublisherControllerTest < ActionDispatch::IntegrationTest
  setup do
    @module_name = 'publisher'
    # users access token
    @token_for_admin = token users(:admin)
    @token_for_test_user = token users(:test_user)

    # A publisher record
    @publisher_A = publishers(:publisher_A)
  end

  test 'should return success response for list all publishers' do
    get_list(@module_name)
    assert_response 200
    
    assert_equal 2, response.parsed_body.count
  end
  
  test 'should fetch a publisher record by ID' do
    get_item(@module_name, @publisher_A.id)
    assert_response 200

    assert_equal @publisher_A.id, response.parsed_body['id']
    assert_equal @publisher_A.name, response.parsed_body['name']
    assert_equal @publisher_A.description, response.parsed_body['description']
  end
  
  test 'should return error response when a record is not found' do
    get_item(@module_name, 11)
    assert_response 404

    assert_equal 'Publisher not found!', response.parsed_body['message']
  end
  
  test 'should create a record by a user' do
    create_item(@module_name, { name: "Publisher TEST", description: "Test test" }, @token_for_admin)
    
    assert_response 201

    @new_publisher = Publisher.find_by(name: 'Publisher TEST')

    assert_equal @new_publisher.id, response.parsed_body['id']
    assert_equal 'admin', response.parsed_body['creator']['username']
    assert_equal 'admin', response.parsed_body['updater']['username']
    assert_equal @new_publisher.name, response.parsed_body['name']
    assert_equal @new_publisher.description, response.parsed_body['description']
  end

  test 'should update a record by another user' do
    update_item(@module_name, @publisher_A.id, { name: "Publisher TEST 1", description: "Test test 1" }, @token_for_test_user)
    
    assert_response 200
    assert_equal 'Publisher "Publisher TEST 1" is updated', response.parsed_body['message']
  end

  test 'should return error message when a record to be updated by unautheticated user' do
    create_item(@module_name, { name: "Publisher TEST 1", description: "Test test 1" })

    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end
  
  test 'should delete a record by user' do
    delete_item(@module_name, @publisher_A.id, @token_for_test_user)
    assert_response 200
    assert_equal "Publisher \"#{@publisher_A.name}\" and its books are deleted", response.parsed_body['message']
  end

  test 'should return error message when a record to be deleted by unautheticated user' do
    delete_item(@module_name, @publisher_A.id, 'something')
    
    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end

  test 'should return error message when a record to be deleted by someone without Authorization' do
    delete_item(@module_name, @publisher_A.id)
    
    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end
end
