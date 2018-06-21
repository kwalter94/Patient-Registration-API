require 'test_helper'

class PrivilegeTest < ActiveSupport::TestCase
   test "insert name before adding privilege" do
    priv = Privilege.new
    assert_not priv.save
   end
end
