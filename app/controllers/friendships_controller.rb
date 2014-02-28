class FriendshipsController < ApplicationController
  before_action :require_user 
  before_action :ensure_friend_exists, 
                :ensure_friend_request_exists,
                :only => [:create]

  def create
    friendship = current_user.befriend(friendship_params)

    if friendship.persisted?
      render :_friendship, :locals => { :friendship => friendship }
    else
      render :json => { :errors => friendship.errors.full_messages },
             :status => :unprocessable_entity
    end
  end

  def index
    friendships = current_user.friendships.includes(:friend)
    render :index, :locals => { :friendships => friendships }
  end

  def destroy
    Friendship.find(params[:id]).try(:destroy)
    render :json => { :success => "Unfriended" }
  end

  private
    
  def friendship_params
    params.require(:friend_id)
  end

  def ensure_friend_exists
    id = friendship_params

    unless User.exists?(id)
      render :json => { :errors => ["User with id #{id} does not exist"] },
             :status => :unprocessable_entity
    end
  end

  def ensure_friend_request_exists
    id = friendship_params
    request = FriendRequest.exists?(:sender_id => id, 
                                    :recipient_id => current_user.id)
    unless request
      render :json => { :errors => ["A friendship request must be sent then accepted before a friendship is created"] },
             :status => :unprocessable_entity
    end
  end
end
