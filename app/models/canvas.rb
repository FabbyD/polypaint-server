class Canvas < ApplicationRecord
  belongs_to :user
  has_many :layers, dependent: :destroy 
  has_secure_password validations: false
end
