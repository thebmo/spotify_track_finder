class UsersController < ApplicationController
  def new
  end

  def create
    # persist form fields
    @email = params[:user][:email]
    @region = params[:user][:region]

    # validate some fields and re-render with errors if we find something
    # otherwise create the user
    if !validate_email(params[:user][:email])
      flash.now[:danger] = "Invalid Email Characters"
    elsif User.find_by(:email => params[:user][:email].downcase)
      flash.now[:danger] = "Email already registered"
    elsif params[:user][:password] != params[:user][:confirm_password]
      flash.now[:danger] = "Passwords do not match"
    elsif !validate_password(params[:user][:password])
      flash.now[:danger] = "Passwords must contain at least one capital and lower case leter, number, and symbol"
    else
      # create new user and redirect!
      redirect_to users_test_path(params: request.parameters)
      return
    end

    render 'new'
  end

  def destroy
  end

  private

  # returns true if all the regex match
  def validate_password(password)
    password.match(/[0-9]/) &&
    password.match(/[A-Z]/) &&
    password.match(/[a-z]/) &&
    password.match(/[!"#$%&'()*+,-.\/:;<=>?@\[\\\]^_`{|}~]/)
  end

  # Validates email meets RFC standards
  # format, special characters, local address length
  def validate_email(email)
    email.match(URI::MailTo::EMAIL_REGEXP) && email.split('@')[0].length < 64
  end
end
