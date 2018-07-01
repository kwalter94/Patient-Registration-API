require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:admin)
    login_as('admin', 'foobar')
  end

  test "should get index" do
    get users_url, as: :json, headers: {'x-api-key': @api_key}
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      post users_url, params: {
        "person_id" => people(:no_user_person).id.to_s,
        "username" => "foobar",
        "password" => "foobar",
        "role" => roles(:clerk).rolename
      }, as: :json, headers: {'x-api-key': @api_key}
    end

    assert_response 201
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      delete user_url(@user), as: :json, headers: {'x-api-key': @api_key}
    end

    assert_response 204
  end

  test "should block access if user not logged in" do
    get roles_url, as: :json
    assert_response 403
  end

  test "should not login with wrong user password combo" do
    post '/login', params: {username: 'yoda', password: 'login I should'}, as: :json
    assert_response 400
  end

  test "should login" do
    post '/login', params: {username: 'foobar', password: 'foobar'}, as: :json
    assert_response 200
  end
end
