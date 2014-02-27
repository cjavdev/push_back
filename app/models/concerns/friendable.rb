module Friendable
  extend ActiveSupport::Concern

  included do
    has_many :friendships, 
      ->(user) { where("user_id = ? OR friend_id = ?", user.id, user.id) }
    has_many :friends, :through => :friendships
  end

  def befriend(user_or_id)
    Friendship.create_friendship(self, user_or_id)
  end

  def unfriend(user_or_id)
    user_or_id = User.id_for(user_or_id)

    friendship = self.friendships
                     .find_by("user_id = ? OR friend_id = ?", user_or_id, user_or_id)

    friendship && friendship.destroy
  end

  module ClassMethods
  end
end