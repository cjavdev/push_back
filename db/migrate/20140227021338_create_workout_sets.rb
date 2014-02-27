class CreateWorkoutSets < ActiveRecord::Migration
  def change
    create_table :workout_sets do |t|
      t.integer :reps
      t.integer :workout_id

      t.timestamps
    end

    add_index :workout_sets, :workout_id
  end
end
