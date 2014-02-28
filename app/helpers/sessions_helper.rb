module SessionsHelper
  def logged_in?
    !!current_user
  end

  def current_user
    @current_user ||= User.first
    # @current_user ||= User.find(2)
  end

  def require_user
    unless logged_in?
      render :json => { :errors => ["User must be logged in"] },
             :status => :forbidden
    end
  end
end