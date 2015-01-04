class FriendshipsController < ApplicationController
  before_action :require_user

  def index
    friendships = current_user.friendships.includes(:friend)
    render :index, locals: { friendships: friendships }
  end

  def destroy
    Friendship.find(params[:id]).try(:destroy)
    render json: { success: "Unfriended" }
  end

  private

  def friendship_params
    params.require(:friend_id)
  end
end
