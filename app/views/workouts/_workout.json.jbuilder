json.id workout.id
json.completed_date workout.completed_date
json.workout_sets do
  json.array! workout.workout_sets, partial: 'workout_sets/workout_set', as: :set
end
