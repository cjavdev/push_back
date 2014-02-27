class UsersController < ApplicationController
  before_action :require_user

  def show
    @user = User.where(id: current_user.id).includes(:workouts, :friendships => [:friend]).first
    render 'users/show.json.jbuilder'
  end
end
