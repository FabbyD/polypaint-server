class CreatePixels < ActiveRecord::Migration[5.1]
  def change
    create_table :pixels do |t|
      t.string :coord
      t.string :color, limit: 6
      t.references :pixel_canvas, foreign_key: true

      t.timestamps
    end
  end
end
