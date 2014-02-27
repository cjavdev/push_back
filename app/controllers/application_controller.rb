class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  respond_to :json

  include SessionsHelper

  def require_user
    unless logged_in?
      render :json => { :error => "must be logged in" },
             :status => :forbidden
    end
  end
end
