class AddSetCountsToSets < ActiveRecord::Migration[7.0]
  def change
    add_column :workout_sets, :set_count, :integer
  end
end
