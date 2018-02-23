class Image < ApplicationRecord
  belongs_to :user
  has_many :strokes, dependent: :destroy 
end
