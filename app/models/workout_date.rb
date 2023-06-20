class WorkoutDate < ApplicationRecord
  validates :date, {presence:true}
end
