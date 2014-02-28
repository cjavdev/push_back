json.partial! 'users/user', user: @user

json.friendships do
  json.array! @user.friendships, partial: 'friendships/friendship', as: :friendship
end

json.workouts do
  json.array! @user.workouts, partial: 'workouts/workout', as: :workout
end

json.received_friend_requests do
  json.array! @user.received_friend_requests do |request|
    json.id request.id
    json.sender do
      json.partial! 'users/user', user: request.sender
    end
    json.created_at request.created_at
  end
end
