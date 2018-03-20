class Layer < ApplicationRecord
  belongs_to :canvas
  has_many :strokes, dependent: :destroy
  has_many :canvas_images, dependent: :destroy
  has_many :textboxes, dependent: :destroy
end
