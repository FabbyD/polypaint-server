class Canvas < ApplicationRecord
  belongs_to :user
  has_many :strokes, dependent: :destroy 
  has_many :canvas_images, dependent: :destroy
end
