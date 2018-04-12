class AddCanvasIdToChatroom < ActiveRecord::Migration[5.1]
  def change
    add_reference :chatrooms, :canvas, foreign_key: true
  end
end
