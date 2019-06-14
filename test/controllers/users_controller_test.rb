require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get users_new_url
    assert_response :success
  end

  setup do
    good_email    = "test@test.com"
    good_pass     = "G00Dpa$$1234"
    @params       = { :user => {
                        :email            => good_email,
                        :password         => good_pass,
                        :password_confirm => good_pass,
                        :region           => 'US' } }.freeze
  end


  test "should redirect on success" do
    post users_new_path, params: params
    assert_redirected_to users_test_path
  end

  test "should validate password complexity" do
    bad_pass = "BADPASS5"
    simple_password_params = params
    simple_password_params[:user][:password] = bad_pass
    simple_password_params[:user][:password_confirm] = bad_pass

    post users_new_path, params: simple_password_params

    assert_response :success
    assert_equal "Passwords must contain at least one capital and lower case leter, number, and symbol",
                 flash[:danger]
  end

  test "should force passwords to be at least 8 characters" do
    short_pass = "2$horT"
    short_password_params = params
    short_password_params[:user][:password] = short_pass
    short_password_params[:user][:password_confirm] = short_pass

    post users_new_path, params: short_password_params

    assert_response :success
    assert_equal "Password length must be at least 8 characters", flash[:danger]
  end

  test "should verify passwords match" do
    miss_matched_params = params
    miss_matched_params[:user][:password_confirm] += "5"

    post users_new_path, params: miss_matched_params

    assert_response :success
    assert_equal "Passwords do not match", flash[:danger]
  end

  test "should sanatize email" do
    invalid_email = "Re@Lb@D$666@test.com"
    invalid_email_params = params
    invalid_email_params[:user][:email] = invalid_email

    post users_new_path, params: invalid_email_params

    assert_response :success
    assert_equal "Invalid Email Characters", flash[:danger]
  end

  test "should enforce email length restrictions" do
    long_email = "Ab" * 33 + "@test.com"
    long_email_params = params
    long_email_params[:user][:email] = long_email

    post users_new_path, params: long_email_params

    assert_response :success
    assert_equal "Email is too long", flash[:danger]
  end

  private
  
  def params
    h = { :user => {} }
    @params[:user].each { |k,v| h[:user][k] = v }

    h
  end
end
