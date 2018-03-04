class CreateCanvasImages < ActiveRecord::Migration[5.1]
  def change
    create_table :canvas_images do |t|
      t.binary :data, null: false, limit: 5.megabyte
      t.integer :pos_x, null: false
      t.integer :pos_y, null: false
      t.references :user, foreign_key: true
      t.references :canvas, foreign_key: true

      t.timestamps
    end
  end
end
