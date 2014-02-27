# == Schema Information
#
# Table name: friendships
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  friend_id  :integer
#  created_at :datetime
#  updated_at :datetime
#

class Friendship < ActiveRecord::Base
  belongs_to :user
  belongs_to :friend,
    :class_name => "User"

  validates :user_id, :friend_id, :presence => true
  validates :user_id, :uniqueness => { :scope => :friend_id }

  def self.create_friendship(user_or_id1, user_or_id2)
    u1 = User.id_for(user_or_id1)
    u2 = User.id_for(user_or_id2)

    f1, f2 = nil, nil
    Friendship.transaction do
      f1 = Friendship.create!(
        user_id: u1,
        friend_id: u2
      )

      f2 = Friendship.create!(
        user_id: u2,
        friend_id: u1
      )
    end

    f1
  end

  def self.destroy_friendship(user_or_id1, user_or_id2)
    u1 = User.id_for(user_or_id1)
    u2 = User.id_for(user_or_id2)

    f1 = Friendship.find_by(:user_id => u1, :friend_id => u2)
    f2 = Friendship.find_by(:user_id => u2, :friend_id => u1)

    Friendship.transaction do
      f1.destroy!
      f2.destroy!
    end
  end
end
