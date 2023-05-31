class CreateWorkoutSets < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_sets do |t|
      t.integer :user_id
      t.integer :workout_id
      t.integer :date_id
      t.float :weight
      t.integer :repetitions

      t.timestamps
    end
  end
end
