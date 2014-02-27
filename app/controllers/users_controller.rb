class UsersController < ApplicationController
  before_action :require_user

  def show
    @user = current_user
    render 'users/show.json.jbuilder'
  end
end
