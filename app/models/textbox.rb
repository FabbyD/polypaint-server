class Textbox < ApplicationRecord
  belongs_to :canvas
  belongs_to :editor, class_name: "User"
end
