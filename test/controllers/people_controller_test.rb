require 'test_helper'

class PersonControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as('foobar', 'foobar')
    @person = people(:foobar)
  end

  test "should get index" do
    get people_url, as: :json, headers: {'API_KEY': @api_key}
    assert_response :success
  end

  test "should create person" do
    assert_difference('Person.count') do
      post people_url, params: {
        'firstname': 'Random',
        'lastname': 'Hacker',
        'gender': 'F'
      }, as: :json, headers: {'API_KEY': @api_key}
    end

    assert_response 201
  end

  test "should show person" do
    get person_url(@person), as: :json, headers: {'API_KEY': @api_key}
    assert_response :success
  end

  test "should update person" do
    patch person_url(@person), params: { person: {  } }, as: :json, headers: {'API_KEY': @api_key}
    assert_response 200
  end

  test "should not destroy attached person" do
    expected_increase = 0
    assert_difference('Person.count', expected_increase) do
      delete person_url(@person), as: :json, headers: {'API_KEY': @api_key}
    end

    assert_response 400
  end

  test "should destroy unattached person" do
    expected_increase = -1
    assert_difference('Person.count', expected_increase) do
      person = people(:unattached_person)
      delete person_url(person, as: :json), headers: {'API_KEY': @api_key}
    end
  end
end
