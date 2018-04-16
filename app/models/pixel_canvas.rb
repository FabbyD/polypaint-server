class PixelCanvas < ApplicationRecord
  belongs_to :user
  has_one :chatroom
  has_secure_password validations: false
end
