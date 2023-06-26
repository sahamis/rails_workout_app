class RemoveUserIdColumns < ActiveRecord::Migration[7.0]
  def change
    remove_column :menu_workouts, :user_id, :integer
    remove_column :menus, :user_id, :integer    
  end
end
