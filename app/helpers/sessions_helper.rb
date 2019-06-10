module SessionsHelper

  # Stores the given users id in the sessions
  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    return unless session[:user_id]
    @current_user ||= User.find(session[:user_id])
  end
end
