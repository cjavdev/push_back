# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  f_name        :string(255)
#  email         :string(255)
#  created_at    :datetime
#  updated_at    :datetime
#  daily_goal    :integer
#  session_token :string(255)
#  l_name        :string(255)
#

class User < ActiveRecord::Base
  include Friendable
  include WorkoutStats
  include Messenger

  before_validation :ensure_session_token

  validates :f_name, :l_name, :email, :session_token, presence: true
  validates :email, :session_token, uniqueness: true

  has_many :authorizations, dependent: :destroy
  has_many :workouts,
    -> { order("completed_date DESC").includes(:workout_sets) }

  def self.id_for(user_or_id)
    user_or_id.try(:id) || user_or_id
  end

  def self.try_find_or_build_from_json!(data)
    return nil unless data[:id]
    if auth = Authorization.find_by_uid(data[:id])
      return auth.user
    else
      user = User.new(scrub_fb_user_data(data).merge(:daily_goal => 50))
      user.authorizations << Authorization.build_from_json!(data)
      user.save!
      return user
    end
    nil
  end

  def self.scrub_fb_user_data(data)
    {
      f_name: data[:first_name],
      l_name: data[:last_name],
      email: data[:email]
    }
  end

  # Dummy method!
  def find_by_credentials(stuff)
    User.first
  end

  def reset_session_token!
    self.session_token = self.class.generate_session_token
    self.save
    self.session_token
  end

  private

  def self.generate_session_token
    SecureRandom.urlsafe_base64(16)
  end

  def ensure_session_token
    self.session_token ||= self.class.generate_session_token
  end
end
