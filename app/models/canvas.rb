class Canvas < ApplicationRecord
  belongs_to :user
  has_many :strokes, dependent: :destroy 
end
