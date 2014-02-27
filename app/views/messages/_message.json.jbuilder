json.message_type message.message_type
if message.message?
  json.body message.body
end
json.author_id message.author_id
json.recipient_id message.recipient_id
json.created_at message.created_at