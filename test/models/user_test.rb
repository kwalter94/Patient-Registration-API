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
    assert new_user.save
  end

  test "Should encrypt password on set_password" do
    user = new_user
    user.set_password 'foobar'
    assert user.password != nil && user.password != 'foobar'
  end

  # Create a new user in memory.
  #
  # By default this method creates a user with all fields set.
  # Specifying fields in parameter `without` forces creation of
  # a user with those fields not set.
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

  test "new uui created" do
    user = new_user
    user.save
    assert user.uuid != nil
  end
end
