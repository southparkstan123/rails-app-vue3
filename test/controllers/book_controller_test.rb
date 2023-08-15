require "test_helper"

class BookControllerTest < ActionDispatch::IntegrationTest
  setup do
    @module_name = 'book'
    # users access token
    @token_for_admin = token users(:admin)
    @token_for_test_user = token users(:test_user)

    # A publisher record
    @publisher_A = publishers(:publisher_A)

    # Authors
    @author_A = authors(:author_A)
    @author_B = authors(:author_B)

    # Books
    @book = books(:book_A)
  end

  # book listing
  test 'should return success response for list all books' do
    get_list(@module_name)
    assert_response 200
    
    assert_equal 4, response.parsed_body.count
  end

  # fetch a book record by ID
  test 'should fetch a book record by ID' do
    get_item(@module_name, @book.id)
    assert_response 200

    assert_equal @book.id, response.parsed_body['id']
    assert_equal @book.name, response.parsed_body['name']
    assert_equal @book.abstract, response.parsed_body['abstract']
  end

  # fetch a book record by ID
  test 'should return error response when a record is not found' do
    get_item(@module_name, 11)
    assert_response 404

    assert_equal 'Book not found!', response.parsed_body['message']
  end

  # create a book record by ID
  test 'should create a record without authors by a user' do
    create_item(@module_name, { name: 'Test book', abstract: 'Testing1234', price: 30.0, publisher_id: @publisher_A['id'] }, @token_for_admin)
    
    assert_response 201

    @new_book = Book.find_by(name: 'Test book')

    assert_equal @new_book.id, response.parsed_body['id']
    assert_equal 'admin', response.parsed_body['creator']['username']
    assert_equal 'admin', response.parsed_body['updater']['username']
    assert_equal @new_book.publisher_id, response.parsed_body['publisher']['id']
  end

  # create a book record by ID
  test 'should create a record with authors by an authenticated user' do
    create_item(@module_name, { 
      name: 'Test book', 
      abstract: 'Testing1234', 
      price: 30.0, 
      publisher_id: @publisher_A['id'],
      author_ids: [@author_A.id, @author_B.id]
    }, @token_for_admin)
    
    assert_response 201

    @new_book = Book.find_by(name: 'Test book')

    assert_equal @new_book.id, response.parsed_body['id']
    assert_equal 'admin', response.parsed_body['creator']['username']
    assert_equal 'admin', response.parsed_body['updater']['username']
    assert_equal @new_book.publisher_id, response.parsed_body['publisher']['id']

    assert_includes response.parsed_body, 'authors'
  end

  # update a book record by ID
  test 'should update a record by another user' do
    update_item(@module_name, @book.id, { 
      name: 'Test book 1',
      abstract: 'Testing1234',
      price: 31.0,
      publisher_id: @publisher_A['id'] 
    }, @token_for_test_user)
    
    assert_response 200
    assert_equal 'Book "Test book 1" is updated', response.parsed_body['message']
  end

  # update a book record by ID
  test 'should return error message when a record to be updated by unautheticated user' do
    update_item(@module_name, @book.id, { 
      name: 'Test book 1', 
      abstract: 'Testing1234', 
      price: 31.0, 
      publisher_id: @publisher_A['id'] 
    })

    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end

  #delete a book record by ID
  test 'should delete a record by user' do
    delete_item(@module_name, @book.id, @token_for_test_user)
    assert_response 200
    assert_equal 'Book "Book A" is deleted', response.parsed_body['message']
  end

  #delete a book record by ID
  test 'should return error message when a record to be deleted by unautheticated user' do
    delete_item(@module_name, @book.id, 'something')
    
    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end

  #delete a book record by ID
  test 'should return error message when a record to be deleted by someone without Authorization' do
    delete_item(@module_name, @book.id)
    
    assert_response 401
    assert_equal 'Unauthorized', response.parsed_body['message']
  end
end
