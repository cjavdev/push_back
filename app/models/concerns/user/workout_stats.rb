class User
  module WorkoutStats
    extend ActiveSupport::Concern

    included do
    end

    def seven_day_count
      self.rep_count(7.days.ago, Date.today)
    end

    def lifetime_total
      self.rep_count(10.years.ago, Date.today)
    end

    def last_rep_count
      workouts.limit(1).first.try(:total_reps)
    end

    def rep_count(start_date, end_date)
      self.workouts
          .completed
          .where("completed_date >= ?", start_date)
          .where("completed_date <= ?", end_date)
          .joins(:workout_sets)
          .sum(:reps)
    end

    module ClassMethods
    end
  end
end