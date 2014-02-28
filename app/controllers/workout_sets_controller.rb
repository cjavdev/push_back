class WorkoutSetsController < ApplicationController
  before_action :require_user
  before_action :find_workout,
                :ensure_owns_workout,
                :only => [:create, :destroy]

  def create
    workout_set = @workout.workout_sets.new(:reps => params.require(:reps))

    if workout_set.save
      render :_workout_set, :locals => { :set => workout_set }
    else
      render :json => { :errors => workout_set.errors.full_messages },
             :status => :unprocessable_entity
    end
  end

  def destroy
    workout_set = WorkoutSet.find(params[:id])
    workout_set.destroy
    render :json => { :success => "Workout set destroyed" }
  end

  private

  def find_workout
    @workout = Workout.find(params[:workout_id])
  end

  def ensure_owns_workout
    unless @workout.user_id == current_user.id
      render :json => { :errors => ["User does not own workout"] },
             :status => :forbidden
    end
  end
end
