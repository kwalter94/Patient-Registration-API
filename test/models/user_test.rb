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

  def new_user(without=[])
    user_data = {
      :username => 'Foobar',
      :password => 'foobar', # This ought to be encrypted in the real world
      :active => 'active',
      :person => people(:kwalter),
      :roles => [roles(:clerk)]
    }

    without.each {|field| user_data[field] = field == :roles and [] or nil}  # Unset all excluded fields

    User.new(user_data)
  end
end
