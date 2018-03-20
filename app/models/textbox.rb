class Textbox < ApplicationRecord
  belongs_to :layer
  belongs_to :editor, class_name: "User"
end
