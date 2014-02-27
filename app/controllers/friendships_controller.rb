class FriendshipsController < ApplicationController
  before_action :require_user 
  before_action :ensure_friend_exists, :only => [:create]

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
    current_user.unfriend(friendship_params)
    render :json => { :success => "Unfriended" }
  end

  private
    
  def friendship_params
    params.require(:friend_id)
  end

  def ensure_friend_exists
    id = friendship_params

    unless User.exists?(id)
      render :json => { :errors => ["User with id #{id} does not exist"] }
    end
  end
end
