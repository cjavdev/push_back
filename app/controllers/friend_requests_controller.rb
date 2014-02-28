class FriendRequestsController < ApplicationController
  before_action :require_user
  before_action :ensure_recipient_id,
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
end
