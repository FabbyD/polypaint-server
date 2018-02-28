class Stroke < ApplicationRecord
  belongs_to :user
  belongs_to :image

  enum shape: [ :ellipse, :rectangle ]
end
