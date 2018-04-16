class AddPixelReferencesToChatroom < ActiveRecord::Migration[5.1]
  def change
    add_reference :chatrooms, :pixel_canvas, foreign_key: true, null: true
  end
end
