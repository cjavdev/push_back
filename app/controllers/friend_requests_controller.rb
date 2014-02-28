class FriendRequestsController < ApplicationController
  before_action :require_user
  before_action :ensure_recipient_id,
                :ensure_recipient_exists,
                :ensure_request_does_not_exist,
                :only => [:create]

  def index
    requests = current_user.received_friend_requests
    render :index, :locals => { :requests => requests }
  end

  def create
    request = current_user.sent_friend_requests.new(:recipient_id => params[:recipient_id])

    if request.save
      render :json => { :success => "Friendship requested" }
    else
      render :json => { :errors => request.errors.full_messages },
             :status => :unprocessable_entity
    end
  end

  private

  def ensure_recipient_id
    params.require(:recipient_id)
  end

  def ensure_recipient_exists
    unless User.exists?(params[:recipient_id])
      render :json => { :errors => ["User with id #{params[:recipient_id]} does not exist"]},
             :status => :unprocessable_entity
    end
  end

  def ensure_request_does_not_exist
    request = FriendRequest.exist?(:sender_id => current_user.id
                                   :recipient_id => params[:recipient_id])
    if request
      render :json => { :errors => ["Cannot request friendship twice"]},
             :status => :unprocessable_entity
    end
  end
end
