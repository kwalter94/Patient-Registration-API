require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:foobar)
  end

  test "should get index" do
    login_as('foobar', 'foobar')
    get users_url, as: :json, headers: {'API_KEY': @api_key}
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      login_as('foobar', 'foobar')
      post users_url, params: {
        "person_id" => people(:no_user_person).id.to_s,
        "username" => "foobar",
        "password" => "foobar",
        "role" => roles(:clerk).rolename
      }, as: :json, headers: {'API_KEY': @api_key}
    end

    assert_response 201
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      login_as('foobar', 'foobar')
      delete user_url(@user), as: :json, headers: {'API_KEY': @api_key}
    end

    assert_response 204
  end

  test "should block access if user not logged in" do
    get roles_url, as: :json
    assert_response 403
  end

  test "should not login with wrong user password combo" do
    post '/login', params: {username: 'yoda', password: 'login I should'}, as: :json
    assert_response 403
  end

  test "should login" do
    post '/login', params: {username: 'foobar', password: 'foobar'}, as: :json
    assert_response 200
  end
end
