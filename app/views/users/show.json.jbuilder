json.partial! 'users/user', user: @user

json.friendships do |friendship|
  json.array! @user.friendships, partial: 'friendships/friendship', as: :friendship
end

json.workouts do |workout|
  json.array! @user.workouts, partial: 'workouts/workout', as: :workout
end