require 'test_helper'

class RolesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as('foobar', 'foobar')
    @role = roles(:clerk)
  end

  test "should get index" do
    get roles_url, as: :json, headers: {'x-api-key': @api_key}
    assert_response :success
  end

  test "should create role" do
    assert_difference('Role.count') do
      post roles_url, params: {name: 'clerk', privileges: ['add']}, as: :json, headers: {'x-api-key': @api_key}
    end

    assert_response 201
  end

  test "should show role" do
    get role_url(@role), as: :json, headers: {'x-api-key': @api_key}
    assert_response :success
  end

  test "should update role" do
    patch role_url(@role), params: {
      'name' => 'clerk',
      'privileges' => ['add']
    }, as: :json, headers: {'x-api-key': @api_key}
    assert_response 204
  end

  test "should destroy role" do
    expected_increase = -1
    assert_difference('Role.count', expected_increase) do
      delete role_url(@role), as: :json, headers: {'x-api-key': @api_key}
    end

    assert_response 204
  end
end
