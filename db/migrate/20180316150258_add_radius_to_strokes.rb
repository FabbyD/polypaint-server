class AddRadiusToStrokes < ActiveRecord::Migration[5.1]
  def change
    add_column :strokes, :radius_x, :float
    add_column :strokes, :radius_y, :float
  end
end
