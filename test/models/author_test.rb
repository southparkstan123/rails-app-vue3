require 'test_helper'

class AuthorTest < ActiveSupport::TestCase
  test 'should not save author without anything' do
    author = Author.new
    assert_not author.save
  end
end
