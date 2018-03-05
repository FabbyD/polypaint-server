class ReplaceDataByUrlInCanvasImages < ActiveRecord::Migration[5.1]
  def change
    add_column :canvas_images, :url, :string, null: false
    remove_column :canvas_images, :data
  end
end
