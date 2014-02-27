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
  validate :cant_friend_self

  def self.create_friendship(user_or_id1, user_or_id2)
    u1 = User.id_for(user_or_id1)
    u2 = User.id_for(user_or_id2)

    f1, f2 = nil, nil
    begin
      Friendship.transaction do
        f1 = Friendship.new(
          user_id: u1,
          friend_id: u2
        )

        f2 = Friendship.new(
          user_id: u2,
          friend_id: u1
        )

        f1.save! && f2.save!
      end
    rescue
      f1
    else
      f1
    end
  end

  def self.destroy_friendship(user_or_id1, user_or_id2)
    u1 = User.id_for(user_or_id1)
    u2 = User.id_for(user_or_id2)

    f1 = Friendship.find_by(:user_id => u1, :friend_id => u2)
    f2 = Friendship.find_by(:user_id => u2, :friend_id => u1)

    begin
      Friendship.transaction do
        f1 && f1.destroy!
        f2 && f2.destroy!
      end
    rescue
      false
    else
      true
    end
  end

  def cant_friend_self
    if self.user_id == self.friend_id
      errors[:user_id] << "can't friend self"
    end
  end
end
