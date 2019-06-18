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
    elsif params[:user][:email].split('@')[0].length > 64
      flash.now[:danger] = "Email is too long"
    elsif User.find_by(:email => params[:user][:email].downcase)
      flash.now[:danger] = "Email already registered"
    elsif params[:user][:password] != params[:user][:password_confirm]
      flash.now[:danger] = "Passwords do not match"
    elsif params[:user][:password].length < 8
      flash.now[:danger] = "Password length must be at least 8 characters"
    elsif !validate_password(params[:user][:password])
      flash.now[:danger] = "Passwords must contain at least one capital and lower case leter, number, and symbol"
    else
      begin
        # create new user and redirect!
        User.transaction do
          user = User.create(
            email: params[:user][:email],
            password: params[:user][:password],
            region: params[:user][:region],
            activated: false)
          log_in(user)

          redirect_to users_test_path
          return
        end
      rescue => e
        flash.now[:danger] = e.message
      end
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
    email.match(URI::MailTo::EMAIL_REGEXP)
  end
end
