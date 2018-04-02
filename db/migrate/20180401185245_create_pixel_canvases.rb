class CreatePixelCanvases < ActiveRecord::Migration[5.1]
  def change
    create_table :pixel_canvases do |t|
      t.string :name
      t.string :thumbnail
      t.references :user, foreign_key: true
      t.boolean :private, default: true
      t.boolean :protected, default: false
      t.string :password_digest
      t.integer :width, default: 400
      t.integer :height, default: 400
      t.string :pixels, array: true, limit: 6, default: Array.new(160000, 'FFFFFF')

      t.timestamps
    end
  end
end
