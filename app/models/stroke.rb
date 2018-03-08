class Stroke < ApplicationRecord
  belongs_to :user
  belongs_to :editor, class_name: "User"
  belongs_to :canvas

  enum shape: [ :ellipse, :rectangle ]
  enum stroke_type: [ :normal, :circle ]
end
