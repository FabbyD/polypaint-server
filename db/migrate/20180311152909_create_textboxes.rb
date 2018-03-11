class CreateTextboxes < ActiveRecord::Migration[5.1]
  def change
    create_table :textboxes do |t|
      t.text :content
      t.references :canvas, foreign_key: true
      t.references :editor, foreign_key: { to_table: :users }

      t.timestamps
    end
  end
end
