# == Schema Information
#
# Table name: messages
#
#  id           :integer          not null, primary key
#  body         :string(255)
#  author_id    :integer
#  recipient_id :integer
#  message_type :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#

class Message < ActiveRecord::Base
end
