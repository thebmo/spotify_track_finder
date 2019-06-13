require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_new_url
    assert_response :success
  end


  test "should sanatize email" do
  end

  test "should validate password complexity" do
  end

  test "should verify passwords match" do
  end
end
