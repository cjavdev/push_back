json.array! requests do |request|
  json.id request.id
  json.recipient_id request.recipient_id
  json.sender json.partial! 'users/user', user: request.sender
end