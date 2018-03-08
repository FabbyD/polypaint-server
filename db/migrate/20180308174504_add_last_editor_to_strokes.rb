class AddLastEditorToStrokes < ActiveRecord::Migration[5.1]
  def change
    add_reference :strokes, :editor, foreign_key: { to_table: :users }
  end
end
