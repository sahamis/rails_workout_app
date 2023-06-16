class AddWorkoutCategory < ActiveRecord::Migration[7.0]
  def change
    add_column :workouts, :category, :string
  end
end
