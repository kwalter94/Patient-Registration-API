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

  test "Should delete only if no user or patient is attached" do
    # Can't destroy person with an attached user and/or client
    person = people(:foobar)
    assert_not(person.destroy(:patient))
    assert_not(person.destroy(:user))
    
    # Can destroy person with no attached user and client
    person = people(:dmr)   # dmr has no user attached
    assert(person.destroy(:patient))

    person = people(:rms)   # rms has no patient attached
    assert(person.destroy(:user))
  end
end
