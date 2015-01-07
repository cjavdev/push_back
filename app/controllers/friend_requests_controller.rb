class FriendRequestsController < ApplicationController
  before_action :require_user
  before_action :find_request,
                :ensure_own_request,
                only: [:accept, :deny]

  def index
    requests = current_user.received_friend_requests
    render :index, locals: { requests: requests }
  end

  def create
    req = FriendRequest.build_for_user_and_fbid(current_user, params[:fbid])

    if req.save
      render json: { success: "Friendship requested" }
    else
      render json: { errors: request.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def accept
    friendship = @request.accept
    if friendship.persisted?
      render :_friendship, locals: { friendship: friendship }
    else
      render json: { errors: friendship.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  def deny
    @request.deny
    render json: { success: "Friend request denied" }
  end

  private

  def find_request
    @request = FriendRequest.find(params[:id])
  end

  def ensure_own_request
    unless current_user.id == @request.recipient_id
      render json: { erorrs: ["This request was not sent to the current user"] },
             status: :unprocessable_entity
    end
  end
end
