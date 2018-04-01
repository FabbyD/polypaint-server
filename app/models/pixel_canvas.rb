class PixelCanvas < ApplicationRecord
  belongs_to :user
  has_many :pixels
  has_secure_password validations: false
end
