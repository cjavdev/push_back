module SessionsHelper
  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.first
  end
end