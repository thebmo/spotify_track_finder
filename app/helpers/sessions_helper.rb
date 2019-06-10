module SessionsHelper

  # Stores the given users id in the sessions
  def log_in(user)
    session[:user_id] = user.id
  end
end
