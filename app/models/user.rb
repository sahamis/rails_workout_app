class User < ApplicationRecord
  validates :name, {presence:true,length:{maximum:30}}
  validates :email, {presence:true}
  validates :password, {presence:true}
end
