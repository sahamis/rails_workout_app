class Menu < ApplicationRecord
  validates :name, {presence:true,length:{maximum:10}}
  validates :routine_id, {presence:true}
end
