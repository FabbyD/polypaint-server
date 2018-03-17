class AddLocalIdToCanvasImages < ActiveRecord::Migration[5.1]
  def change
    add_column :canvas_images, :local_id, :string, null: false
  end
end
