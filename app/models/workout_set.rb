class WorkoutSet < ApplicationRecord
  validates :user_id, {presence:true}
  validates :date_id, {presence:true}
  validates :workout_id, {presence:true}
  validates :weight, {presence:true}
  validates :repetitions, {presence:true}
end
