require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "Should not create user without username" do
    assert_not new_user(without = [:username]).save
  end

  test "Should not create user without person" do
    assert_not new_user(without = [:person]).save
  end

  test "Should not create user without password" do
    assert_not new_user(without = [:password]).save
  end

  test "Should not create user without role" do
    assert_not new_user(without = [:roles]).save
  end

  test "Should be able to create user with valid data" do
    user = new_user
    user_saved = user.save
    puts user.errors.messages
    assert user_saved
  end

  def new_user(without=[])
    user = User.new

    for field in [:username, :password, :active, :person, :roles]
      next if without.include? field  # Skip all fields in without

      case field
        when :username then
          user.username = 'Foobar'
        when :password then
          user.password = 'foobar'
        when :active then
          user.active = true
        when :person then
          user.person = Person.new :gender => 'male'
        when :roles then
          user.roles << roles(:clerk)
      end
    end
  
    user
  end
end
