class FriendRequestsController < ApplicationController
  before_action :require_user
  before_action :find_request,
                :ensure_own_request,
                only: [:accept, :deny]

  def index
    if params[:type] == "sent"
      requests = current_user.sent_friend_requests
    else
      requests = current_user.received_friend_requests
    end

    render :index, locals: { requests: requests }
  end

  def create
    req = FriendRequest.build_for_user_and_fbid(current_user, params[:fbid])

    if req.save
      render json: { success: "Friendship requested" }
    else
      render json: { errors: req.errors.full_messages }, status: 422
    end
  end

  def accept
    friendship = @request.accept
    if friendship.persisted?
      render json: friendship
    else
      render json: { errors: friendship.errors.full_messages }, status: 422
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
