class AddSizeToCanvases < ActiveRecord::Migration[5.1]
  def change
    add_column :canvases, :width, :float, default: 550
    add_column :canvases, :height, :float, default: 310
  end
end
