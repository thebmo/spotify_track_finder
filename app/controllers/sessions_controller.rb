class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)

    # TODO 6.4.2019: authenticate password
    if user && user.authenticate(params[:session][:password])
      # login and redirect
      # TODO 6.4.2019: update redirect path
      #   add a previous_url redirect else index
      redirect_to users_test_path
    else
      # TODO 6.4.2019: add a login failure message
      # TODO 6.4.2019: limit failed log in attempts by email/ip
      flash[:danger] = 'Invalid email/password combination'

      render 'new'
    end
  end

  def destroy
  end
end
