class Stroke < ApplicationRecord
  belongs_to :user
  belongs_to :canvas

  enum shape: [ :ellipse, :rectangle ]
  enum stroke_type: [ :normal, :circle ]
end
