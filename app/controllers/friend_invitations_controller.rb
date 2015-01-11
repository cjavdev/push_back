class FriendInvitationsController < ApplicationController
  def create
    @invitation = Invitation.new(current_user, params[:email])

    if @invitation.save
      render json: @invitation
    else
      render json: @invitation.errors
    end
  end
end
