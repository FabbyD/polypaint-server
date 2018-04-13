class Canvas < ApplicationRecord
  belongs_to :user
  has_many :layers, dependent: :destroy 
  has_one :chatroom
  belongs_to :template, optional: true
  has_secure_password validations: false
end
