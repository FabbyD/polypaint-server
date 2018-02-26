class Stroke < ApplicationRecord
  belongs_to :user
  belongs_to :image

  enum shape: [ :circle, :square, :hline, :vline ]
end
