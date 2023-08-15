require 'test_helper'

class BookTest < ActiveSupport::TestCase
  test 'should not save book without anything' do
    book = Book.new
    assert_not book.save
  end
end
