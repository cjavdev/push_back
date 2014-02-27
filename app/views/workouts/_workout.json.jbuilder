json.id workout.id
json.completed_date workout.completed_date
json.workout_sets workout.workout_sets do |set|
  json.id set.id
  json.reps set.reps
  json.workout_id set.workout_id
end