class Workout < ApplicationRecord
  validates :name, {presence:true,length:{maximum:10}}
end
