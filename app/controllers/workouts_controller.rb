class WorkoutsController < ApplicationController
  before_action :require_user
  before_action :find_workout,
                :ensure_owns_workout,
                only: [:show, :update, :destroy]

  def index
    workouts = current_user.workouts
    render :index, locals: { workouts: workouts }
  end

  def create
    workout = current_user.workouts.create
    render :_workout, locals: { workout: workout }
  end

  def show
    render :_workout, locals: { workout: @workout }
  end

  def update
    @workout.update_attributes(completed_date: Date.today)
    render :_workout, locals: { workout: @workout }
  end

  def destroy
    @workout.destroy
    render json: { success: "Workout destroyed" }
  end

  private

  def find_workout
    @workout = Workout.find(params[:id])
  end

  def ensure_owns_workout
    unless @workout.user_id == current_user.id
      render json: { errors: ["User doesn't own this workout"] },
             status: :forbidden
    end
  end
end
