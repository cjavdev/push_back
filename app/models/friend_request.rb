class FriendRequest < ActiveRecord::Base
  belongs_to :sender, 
             :class_name => "User"

  belongs_to :recipient,
             :class_name => "User"

  validates :sender_id, :recipient_id, :presence => true
  validates :sender_id, :uniqueness => { :scope => :recipient_id }
  validate :no_two_way_requests, :recipient_exists

  def self.pending
    where(:pending => true)
  end

  def no_two_way_requests
    # i.e. If request goes both ways, then friendship should be created
    request = FriendRequest.exists?(:sender_id => self.recipient_id,
                                    :recipient_id => self.sender_id)
    if request
      errors[:recipient_id] << "cannot request friendship back"
    end
  end

  def recipient_exists
    unless User.exists?(self.recipient_id)
      errors[:recipient_id] << "does not exist"
    end
  end
end
