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

    def cheer(user)
      Message.create_cheer(self, user)
    end

    def taunt(user)
      Message.create_taunt(self, user)
    end

    def message(user, body)
      Message.create_message(self, user, body)
    end

    module ClassMethods
    end
  end
end