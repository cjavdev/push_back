json.array! requests do |req|
  json.id req.id
  json.recipient_id req.recipient_id
  json.sender_id req.sender_id

  if params[:type] == "sent"
    json.recipient do
      json.partial! 'users/user', user: req.recipient
    end
  else
    json.sender do
      json.partial! 'users/user', user: req.sender
    end
  end
end
