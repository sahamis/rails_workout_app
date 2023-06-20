class CreateMenuWorkouts < ActiveRecord::Migration[7.0]
  def change
    create_table :menu_workouts do |t|
      t.integer :menu_id
      t.integer :workout_id

      t.timestamps
    end
  end
end
