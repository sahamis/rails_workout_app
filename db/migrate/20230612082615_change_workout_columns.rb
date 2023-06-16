class ChangeWorkoutColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :workouts, :category
    add_column :workouts, :category_id, :integer
  end
end
