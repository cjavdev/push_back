class FriendRequest < ActiveRecord::Base
  belongs_to :sender, 
             :class_name => "User"

  belongs_to :recipient,
             :class_name => "User"

  def self.pending
    where(:pending => true)
  end
end
