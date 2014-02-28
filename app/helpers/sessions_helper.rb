module SessionsHelper
  def login(user)
    token = user.reset_session_token!
    session[:token] = token
  end

  def logout
    current_user.reset_session_token!
    session[:token] = nil
  end

  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.first
    # @current_user ||= User.find(2)
    # @current_user ||= User.find_by(:session_token => session[:token])
  end

  def require_user
    unless logged_in?
      render :json => { :errors => ["User must be logged in"] },
             :status => :forbidden
    end
  end
end