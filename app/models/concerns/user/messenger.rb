class User
  module Messenger
    extend ActiveSupport::Concern

    included do
      has_many :authored_messages,
        :class_name => "Message",
        :foreign_key => :author_id

      has_many :received_messages,
        :class_name => "Message",
        :foreign_key => :recipient_id
    end

    def conversation_with(user)
      Message.conversation_between(self, user)
    end

    # #cheer, #taunt, #message
    Message::MESSAGE_TYPES.each do |type|
      define_method(type.to_sym) do |user, body = nil|
        Message.send("create_#{type}", self, user, body)
      end
    end

    module ClassMethods
    end
  end
end