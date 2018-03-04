class RenameImagesTableToCanvasesTable < ActiveRecord::Migration[5.1]
  def change
    rename_table :images, :canvases
    rename_column :strokes, :image_id, :canvas_id
  end
end
