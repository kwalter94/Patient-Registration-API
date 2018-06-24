require 'test_helper'

class PersonNameTest < ActiveSupport::TestCase
  test 'should not create without firstname' do
    assert_not PersonName.new(lastname: 'foobar', person: people(:foobar)).save
  end

  test 'should not create without lastname' do
    assert_not PersonName.new(firstname: 'foobar', person: people(:foobar)).save
  end

  test 'should not create without person' do
    assert_not PersonName.new(firstname: 'foobar', lastname: 'J.Random').save
  end

  test "should create given all parameters" do
    assert PersonName.new(firstname: 'J.Random', lastname: 'Hacker',
                          person: people(:foobar)).save
  end
end
