class MenuWorkout < ApplicationRecord
  validates :menu_id, {presence:true}
  validates :workout_id, {presence:true}
end
