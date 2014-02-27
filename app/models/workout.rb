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
  has_many :sets, 
    :class_name => "WorkoutSet"

  belongs_to :user

  def self.create_template_sets(rep_counts)
    Workout.transaction do 
      workout = Workout.create!
      reps = rep_counts.map { |count| { :reps => count } }
      workout.sets.create!(reps)
    end
  end

  def self.templates
    where(:user_id => nil)
  end

  def self.completed
    where.not(:completed_date => nil)
  end

  def completed?
    !!self.completed_date
  end

  def template?
    !!self.user_id
  end

  def total_reps
    sets.sum(:reps)
  end
end
