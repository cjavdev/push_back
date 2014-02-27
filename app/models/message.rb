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
  MESSAGE_TYPES = %w(message cheer taunt)
  validates :message_type, :inclusion => { :in => MESSAGE_TYPES }

  validates :author_id, :recipient_id, :message_type, :presence => true

  default_scope { order("created_at DESC") }

  class << self
    MESSAGE_TYPES.each do |type|
      # Scopes: messages, cheers, taunts
      define_method("#{type}s".to_sym) do
        where(:message_type => type)
      end

      # Factory methods: create_cheer, create_taunt, create_message
      define_method("create_#{type}".to_sym) do |author_id, recipient_id, body = nil|
        author_id = User.id_for(author_id)
        recipient_id = User.id_for(recipient_id)

        body = nil if ["cheer", "taunt"].include?(type)

        Message.create(
          :author_id => author_id,
          :recipient_id => recipient_id,
          :message_type => type,
          :body => body
        )
      end
    end
  
    def conversation_between(user_or_id1, user_or_id2)
      u1 = User.id_for(user_or_id1)
      u2 = User.id_for(user_or_id2)

      Message.where("(author_id = ? AND recipient_id = ?) OR (recipient_id = ? AND author_id = ?)", u1, u2, u1, u2)
    end
  end

  MESSAGE_TYPES.each do |type|
    # #taunt?, #cheer?, #message?
    define_method("#{type}?".to_sym) do
      self.message_type == type
    end
  end
end
