class MessagesController < ApplicationController
  before_action :require_user
  before_action :ensure_message_type,
                :ensure_friends,
                only: :create

  def index
    messages = current_user.conversation_with(params[:friend_id])
    render :index, locals: { messages: messages }
  end

  def create
    message = current_user.send(params[:message_type].to_sym, params[:friend_id], params[:body])
    render :_message, locals: { message: message }
  end

  private

  def ensure_message_type
    unless Message::MESSAGE_TYPES.include?(params[:message_type])
      render json: { errors: ["Message type must be in [#{Message::MESSAGE_TYPES.join(', ')}]"] },
             status: :unprocessable_entity
    end
  end

  def ensure_friends
    unless current_user.friends_with?(params[:friend_id])
      render json: { errors: ["You can only message people you're friends with."] },
             status: :unprocessable_entity
    end
  end
end
