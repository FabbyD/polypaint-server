class AddSizeAndRotationToCanvasImages < ActiveRecord::Migration[5.1]
  def change
    add_column :canvas_images, :width, :float
    add_column :canvas_images, :height, :float
    add_column :canvas_images, :rotation, :float, default: 0
  end
end
