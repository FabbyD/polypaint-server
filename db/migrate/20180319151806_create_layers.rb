class CreateLayers < ActiveRecord::Migration[5.1]
  def change
    create_table :layers do |t|
      t.string :uuid, null: false, uniq: true
      t.integer :index, null: false, uniq: true
      t.references :canvas, null: false, foreign_key: true, index: true

      t.timestamps
    end
  end
end
