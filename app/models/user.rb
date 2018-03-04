class User < ApplicationRecord
  has_many :messages
  has_many :chatrooms, through: :messages
  has_many :strokes
  has_many :canvas_images
  validates :name, presence: true, uniqueness: true
  has_secure_password
end
