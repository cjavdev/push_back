class User
  module Friendable
    extend ActiveSupport::Concern

    included do
      has_many :friendships
      has_many :friends, :through => :friendships
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