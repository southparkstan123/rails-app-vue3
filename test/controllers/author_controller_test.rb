require "test_helper"

class AuthorControllerTest < ActionDispatch::IntegrationTest
  setup do
    @module_name = 'author'
    # users access token
    @token_for_admin = token users(:admin)
    @token_for_test_user = token users(:test_user)

    # A author record
    @author_A = authors(:author_A)
  end

  test 'should return success response for list all authors' do
    get_list(@module_name)
    assert_response 200
    
    assert_equal 2, response.parsed_body.count
  end
  
  test 'should fetch a publisher record by ID' do
    get_item(@module_name, @author_A.id)
    assert_response 200

    assert_equal @author_A.id, response.parsed_body['id']
    assert_equal @author_A.name, response.parsed_body['name']
    assert_equal @author_A.description, response.parsed_body['description']
  end
  
  test 'should return error response when a record is not found' do
    get_item(@module_name, 11)
    assert_response 404

    assert_equal 'Author not found!', response.parsed_body['message']
  end
  
  test 'should create a record by a user' do
    create_item(@module_name, { name: "New author", description: "This is an new author" }, @token_for_admin)
    
    assert_response 201

    @new_author = Author.find_by(name: 'New author')

    assert_equal @new_author.id, response.parsed_body['id']
    assert_equal 'admin', response.parsed_body['creator']['username']
    assert_equal 'admin', response.parsed_body['updater']['username']
    assert_equal @new_author.name, response.parsed_body['name']
    assert_equal @new_author.description, response.parsed_body['description']
  end

  test 'should update a record by another user' do
    update_item(@module_name, @author_A.id, { name: "New author 1", description: "This is an new author" }, @token_for_test_user)
    
    assert_response 200
    assert_equal 'Author "New author 1" is updated', response.parsed_body['message']
  end

  test 'should return error message when a record to be updated by unautheticated user' do
    create_item(@module_name, { name: "Another new author", description: "This is an new author 2" })

    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end
  
  test 'should delete a record by user' do
    delete_item(@module_name, @author_A.id, @token_for_test_user)
    assert_response 200
    assert_equal "Author \"#{@author_A.name}\" is deleted", response.parsed_body['message']
  end

  test 'should return error message when a record to be deleted by unautheticated user' do
    delete_item(@module_name, @author_A.id, 'something')
    
    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end

  test 'should return error message when a record to be deleted by someone without Authorization' do
    delete_item(@module_name, @author_A.id)
    
    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end
end
