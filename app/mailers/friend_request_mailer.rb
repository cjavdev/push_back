class FriendRequestMailer < ActionMailer::Base
  default from: "challenge@pushbit.io"

  def invite(from, to)
    @from = from
    mail to: to
  end
end
