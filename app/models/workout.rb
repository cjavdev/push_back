# == Schema Information
#
# Table name: workouts
#
#  id             :integer          not null, primary key
#  completed_date :date
#  user_id        :integer
#  created_at     :datetime
#  updated_at     :datetime
#

class Workout < ActiveRecord::Base
end
