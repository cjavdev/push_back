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

  validates :f_name, :l_name, :email, :presence => true
  validates :email, :uniqueness => true

  has_many :workouts,
    -> { order("completed_date DESC").includes(:workout_sets) }

  def self.id_for(user_or_id)
    user_or_id.try(:id) || user_or_id
  end
end
