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
    user = User.first
    login(user)
    render :show, locals: { user: user }
  end

  def update
  end

  private

  def user_params
  end
end
