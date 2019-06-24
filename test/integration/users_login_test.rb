require 'test_helper'

class UserLoginTest < ActionDispatch::IntegrationTest

  test "login with invalid information" do
    get login_path
    post login_path, params: { session: { email: "", password: "" } }
    
    assert_not flash.empty?

    get users_test_path
    assert flash.empty?
  end
end
