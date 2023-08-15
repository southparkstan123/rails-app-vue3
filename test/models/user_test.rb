require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test 'should not save user without anything' do
    user = User.new
    assert_not user.save
  end

  test 'should not save user without username' do
    user = User.create(password: 'testing1234', email: 'admin@railsapp.com')
    assert_not user.save
  end

  test 'should not save user without password' do
    user = User.create(username: 'testing1234', email: 'admin@railsapp.com')
    assert_not user.save
  end

  test 'should not save user without email' do
    user = User.create(username: 'testing1234', password: 'pasSwoRd123')
    assert_not user.save
  end

  test 'should not save user with empty username' do
    user = User.create(username: '', password: 'testing1234', email: 'admin@railsapp.com')
    assert_not user.save
  end

  test 'should not save user with empty password' do
    user = User.create(username: 'someuser', password: '', email: 'admin@railsapp.com')
    assert_not user.save
  end

  test 'should not save user with invalid email' do
    user = User.create(username: 'someuser', password: 'testing1234', email: 'sometext')
    assert_not user.save
  end

  test 'should save user' do
    user = User.create(username: 'testing1234', password: 'testing1234', email: 'testing1234@railsapp.com')
    assert user.save
  end

  test 'should not save user which username is already existed' do
    user1 = User.create(username: 'someuser', password: 'testing1234', email: 'example@somehost.com')
    assert user1.save
    user2 = User.create(username: 'someuser', password: 'testing1234', email: 'example2@somehost.com')
    assert_not user2.save
  end

  test 'should not save user which email is already existed' do
    user1 = User.create(username: 'someuser', password: 'testing1234', email: 'example@somehost.com')
    assert user1.save
    user2 = User.create(username: 'someuser2', password: 'testing1234', email: 'example@somehost.com')
    assert_not user2.save
  end

  test 'should save another user' do
    user1 = User.create(username: 'someuser', password: 'testing1234', email: 'example@somehost.com')
    assert user1.save
    user2 = User.create(username: 'someuser2', password: 'testing1234', email: 'example2@somehost.com')
    assert user2.save
  end
end
