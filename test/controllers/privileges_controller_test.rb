require 'test_helper'

class PrivilegesControllerTest < ActionDispatch::IntegrationTest
  setup do
    login_as('foobar', 'foobar')
    @privilege = privileges(:add)
  end

  test "should get index" do
    get privileges_url, as: :json, headers: {'x-api-key': @api_key}
    assert_response :success
  end

  test "should create privilege" do
    assert_difference('Privilege.count') do
      post privileges_url, params: {name: 'add'}, as: :json, headers: {'x-api-key': @api_key}
    end

    assert_response 201
  end

  test "should show privilege" do
    get privilege_url(@privilege), as: :json, headers: {'x-api-key': @api_key}
    assert_response :success
  end

  test "should update privilege" do
    patch privilege_url(@privilege), params: { privilege: {  } }, as: :json, headers: {'x-api-key': @api_key}
    assert_response 204
  end

  test "should destroy privilege" do
    expected_increase = -1
    assert_difference('Privilege.count', expected_increase) do
      delete privilege_url(@privilege), as: :json, headers: {'x-api-key': @api_key}
    end

    assert_response 204
  end
end
