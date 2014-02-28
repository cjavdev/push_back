class RemoveUniqueIndexOnFriendships < ActiveRecord::Migration
  def up
    remove_index :friendships, [:user_id, :friend_id]
  end

  def down
    add_index :friendships, [:user_id, :friend_id], unique: true
  end
end
