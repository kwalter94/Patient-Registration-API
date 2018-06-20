require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "Should create person without birthdate" do
    # NOTE: Creating people without a date of birth is allowed because
    # there are people out there who do not know their date of birth.
    assert Person.new(:birthdate => nil, :gender => 'M').save
  end

  test "Should not create person without gender" do
    assert_not Person.new(:gender => nil).save
  end
end
