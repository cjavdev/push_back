class UsersController < ApplicationController
  before_action :require_user

  def show
    @user = User.where(id: current_user.id)
                .limit(1)
                .includes(:workouts, 
                          friendships: [:friend], 
                          received_friend_requests: [:sender])
                .first
    render 'users/show.json.jbuilder'
  end
end
