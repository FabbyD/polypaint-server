class CreatePixelCanvases < ActiveRecord::Migration[5.1]
  def change
    create_table :pixel_canvases do |t|
      t.string :name
      t.string :thumbnail
      t.references :user, foreign_key: true
      t.boolean :private, default: true
      t.boolean :protected, default: false
      t.string :password_digest

      t.timestamps
    end
  end
end
