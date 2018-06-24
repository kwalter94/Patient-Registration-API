require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  test "should create person given full details" do
    assert Person.new(person_name: person_names(:foobar),
                      gender: 'M',
                      birthdate: Time.now.to_date).save
  end

  test "should create person without birthdate" do
    # NOTE: Creating people without a date of birth is allowed because
    # there are people out there who do not know their date of birth.
    assert Person.new(person_name: person_names(:foobar), gender: 'M').save
  end

  test "should not create person without gender" do
    assert_not Person.new(person_name: person_names(:foobar),
                          birthdate: Time.now.to_date).save
  end

  test "should not create person without name" do
    assert_not Person.new(birthdate: Time.now.to_date, gender: 'F').save
  end

  test "should destroy if no user is attached and patient is ignored" do
    person = people :no_user_person
    assert person.destroy(ignore = :patient)
  end

  test "should destroy if no patient is attached and user is ignored" do
    person = people :no_patient_person
    assert person.destroy(ignore = :user)
  end

  test "should not destroy if both patient and person are attached" do
    person = people(:foobar)
    assert_not person.destroy
  end

  test "should destroy if no user and patient is attached" do
    # Can't destroy person with an attached user and/or client
    person = Person.new(person_name: person_names(:foobar),
                        gender: 'M',
                        birthdate: Time.now.to_date)
    person.save
    assert person.destroy
  end
end
