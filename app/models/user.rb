class User < ApplicationRecord
  has_secure_password
  
  has_many :rooms
  has_many :reservations

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
end
