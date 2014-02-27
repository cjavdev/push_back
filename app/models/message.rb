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
    # Scopes: messages, cheers, taunts
    MESSAGE_TYPES.each do |type|
      define_method("#{type}s".to_sym) do
        where(:message_type => type)
      end

      define_method("#{type}?".to_sym) do
        self.message_type == type
      end
    end
  
    def conversation_between(user_or_id1, user_or_id2)
      u1 = User.id_for(user_or_id1)
      u2 = User.id_for(user_or_id2)

      Message.where("(author_id = ? AND recipient_id = ?) OR (recipient_id = ? AND author_id = ?)", u1, u2, u1, u2)
    end

    def create_cheer(author_id, recipient_id)
      Message.create(
        :author_id => author_id,
        :recipient_id => recipient_id,
        :message_type => "cheer"
      )
    end

    def create_taunt(author_id, recipient_id)
      Message.create(
        :author_id => author_id,
        :recipient_id => recipient_id,
        :message_type => "taunt"
      )
    end

    def create_message(author_id, recipient_id, body)
      Message.create(
        :author_id => author_id,
        :recipient_id => recipient_id,
        :body => body,
        :message_type => "message"
      )
    end
  end
end
