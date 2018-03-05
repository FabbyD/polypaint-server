class AddStrokeTypeToStrokes < ActiveRecord::Migration[5.1]
  def change
    add_column :strokes, :stroke_type, :integer, null: false, default: 0
  end
end
