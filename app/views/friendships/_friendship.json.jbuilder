json.id friendship.id

json.friend do 
  json.partial! 'users/user', user: friendship.friend
end

json.messages do
  json.array! current_user.conversation_with(friendship.friend_id), partial: 'messages/message', as: :message
end