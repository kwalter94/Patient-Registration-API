require 'test_helper'

class PatientsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @patient = patients(:barfoo)
  end

  test "should get index" do
    get patients_url, as: :json
    assert_response :success
  end

  test "should create patient" do
    assert_difference('Patient.count') do
      post patients_url, params: { patient: {  } }, as: :json
    end

    assert_response 201
  end

  test "should show patient" do
    get patient_url(@patient), as: :json
    assert_response :success
  end

  test "should update patient" do
    patch patient_url(@patient), params: { patient: {  } }, as: :json
    assert_response 200
  end

  test "should destroy patient" do
    expected_increase = 1
    assert_difference('Patient.count(:deleted_at)', expected_increase) do
      delete patient_url(@patient), as: :json
    end

    assert_response 204
  end
end
