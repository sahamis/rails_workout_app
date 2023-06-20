class Routine < ApplicationRecord
  validates :name, {presence:true,length:{maximum:10}}
end
