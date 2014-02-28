class UsersController < ApplicationController
  before_action :require_user, except: [:create]

  def show
    user = User.where(id: current_user.id)
               .limit(1)
               .includes(:workouts,
                         friendships: [:friend],
                         received_friend_requests: [:sender])
               .first
    render :show, locals: { user: user }
  end

  def destroy
    confirmation = params.require(:confirmation)
    confirmation && current_user.destroy
  end

  def create
    # Handle first-time Facebook Login
    # find or create user
    # user = User.find_by(email: params[:email])
    # user = User.create(user_params) unless user
    user = User.first
    login(user)
    render :show, locals: { user: user }
  end

  def update
    current_user.update_attributes(user_params)
    render :_user, locals: { user: current_user }
  end

  private

  def user_params
    params.require(:user).permit(:f_name, :l_name, :email, :daily_goal)
  end
end
