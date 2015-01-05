class Invitation
  attr_reader :from_user, :to_email

  def initialize(from_user, to_email)
    @from_user = from_user
    @to_email = to_email
  end

  def to_user
    User.find_by(email: to_email)
  end

  def friend_request
    FriendRequest.new(sender_id: from_user.id, recipient_id: to_user.id)
  end

  def save
    return friend_request.save if valid?

    FriendRequestMailer.invite(from_user.email, to_email).deliver
  end

  def valid?
    validate!
    errors.empty?
  end

  def validate!
    unless to_user
      errors.push('Recipient not found')
    end
  end

  def errors
    @errors ||= []
  end
end
