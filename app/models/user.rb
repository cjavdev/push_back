# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  f_name     :string(255)
#  l_name     :string(255)
#  email      :string(255)
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  include Friendable
  include WorkoutStats
  include Messenger

  before_validation :ensure_session_token

  validates :f_name, :l_name, :email, :session_token, presence: true
  validates :email, :session_token, uniqueness: true

  has_many :workouts,
    -> { order("completed_date DESC").includes(:workout_sets) }

  def self.id_for(user_or_id)
    user_or_id.try(:id) || user_or_id
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
