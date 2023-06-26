class AddUserIdColumns < ActiveRecord::Migration[7.0]
  def change
    add_column :categories, :user_id, :integer
    add_column :menus, :user_id, :integer
    add_column :routines, :user_id, :integer
    add_column :workouts, :user_id, :integer
    add_column :menu_workouts, :user_id, :integer
  end
end
