class User
  module Friendable
    extend ActiveSupport::Concern

    included do
      has_many :friendships
      has_many :friends, :through => :friendships

      has_many :received_friend_requests,
               :class_name => "FriendRequest",
               :foreign_key => :recipient_id

      has_many :sent_friend_requests,
               :class_name => "FriendRequest",
               :foreign_key => :sender_id
    end

    def accept_friendship(user_or_id)
      user_or_id = User.id_for(user_or_id)
      request = FriendRequest.find_by(:sender_id => user_or_id, 
                                      :recipient_id => self.id)
      return false unless request

      User.transaction do
        request.destroy!
        befriend(user_or_id)
      end
    end

    def deny_friendship(user_or_id)
      user_or_id = User.id_for(user_or_id)
      request = FriendRequest.find_by(:sender_id => user_or_id, 
                                      :recipient_id => self.id)
      return false unless request

      request.destroy!
    end

    def befriend(user_or_id)
      Friendship.create_friendship(self, user_or_id)
    end

    def unfriend(user_or_id)
      Friendship.destroy_friendship(self, user_or_id)
    end

    def friends_with?(user_or_id)
      user_or_id = User.id_for(user_or_id)
      Friendship.exists?(:user_id => self.id, :friend_id => user_or_id)
    end

    module ClassMethods
    end
  end
end