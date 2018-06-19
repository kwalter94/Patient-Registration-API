require 'test_helper'

class RoleTest < ActiveSupport::TestCase
  test "Can not create role with rolename" do
    role = Role.new
    assert_not role.save
  end

  test "Should create role with rolename" do
    role = Role.new :rolename => 'foobar'
    assert role.save
  end
end
