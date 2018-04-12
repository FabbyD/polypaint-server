class Chatroom < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :users, through: :messages
  belongs_to :canvas
  validates :name, presence: true, uniqueness: true
end
