class RemoveNullConstraintOnCanvasForChatroom < ActiveRecord::Migration[5.1]
  def change
    change_column_null :chatrooms, :canvas_id, true
  end
end
