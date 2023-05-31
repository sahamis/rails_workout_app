class CreateWorkoutDates < ActiveRecord::Migration[7.0]
  def change
    create_table :workout_dates do |t|
      t.date :date
      t.text :notes

      t.timestamps
    end
  end
end
