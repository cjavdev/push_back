class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.date :completed_date
      t.integer :user_id

      t.timestamps
    end

    add_index :workouts, :user_id
  end
end
