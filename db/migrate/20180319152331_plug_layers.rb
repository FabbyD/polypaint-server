class PlugLayers < ActiveRecord::Migration[5.1]
  def change
    remove_reference :strokes, :canvas, index: true, foreign_key: true
    add_reference :strokes, :layer, null: false, index: true, foreign_key: true
    remove_reference :canvas_images, :canvas, index: true, foreign_key: true
    add_reference :canvas_images, :layer, null: false, index: true, foreign_key: true
    remove_reference :textboxes, :canvas, index: true, foreign_key: true
    add_reference :textboxes, :layer, null: false, index: true, foreign_key: true
  end
end
