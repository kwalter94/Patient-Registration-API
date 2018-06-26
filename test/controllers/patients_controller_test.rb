require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as('foobar', 'foobar')
    @patient = patients(:barfoo)
  end

  test "should get index" do
    get patients_url, as: :json, headers: {'x-api-key': @api_key}
    assert_response :success
  end

  test "should create patient" do
    assert_difference('Patient.count') do
      person_id = people(:unattached_person).id.to_s
      post patients_url, params: { person_id: person_id }, as: :json, headers: {'x-api-key': @api_key}

    end

    assert_response 201
  end

  test "should show patient" do
    get patient_url(@patient), as: :json, headers: {'x-api-key': @api_key}
    assert_response :success
  end

  test "should update patient" do
    new_person_id = people(:unattached_person).id.to_s
    patch patient_url(@patient), params: { person_id: new_person_id }, as: :json, headers: {'x-api-key': @api_key}
    assert_response 204
  end

  test "should destroy patient" do
    expected_increase = -1
    assert_difference('Patient.count', expected_increase) do
      delete patient_url(@patient), as: :json, headers: {'x-api-key': @api_key}
    end

    assert_response 204
  end
end
