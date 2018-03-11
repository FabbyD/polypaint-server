class CreateTextboxes < ActiveRecord::Migration[5.1]
  def change
    create_table :textboxes do |t|
      t.text :content, default: ""
      t.integer :pos_x, null: false
      t.integer :pos_y, null: false
      t.references :canvas, foreign_key: true, null: false
      t.references :editor, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end
  end
end
