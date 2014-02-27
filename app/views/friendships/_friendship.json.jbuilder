json.id friendship.id

json.friend do 
  json.partial! 'users/user', user: @user
end

json.messages do
  json.array! @user.conversation_with(friendship.friend_id), partial: 'messages/message', as: :message
end