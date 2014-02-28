class SessionsController < ApplicationController
  before_action :require_user, only: :destroy

  def create
    user = User.find_by_credentials("stuff")
    if user
      login(user)
      render json: { token: user.session_token }
    else
      render json: { errors: ["Invalid credentials"] },
             status: :forbidden
    end
  end

  def destroy
    logout
    render json: { success: "Logged out" }
  end
end
