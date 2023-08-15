require 'test_helper'

class PublisherTest < ActiveSupport::TestCase
  test 'should not save publisher without anything' do
    publisher = Publisher.new
    assert_not publisher.save
  end
end
