class CreateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :templates do |t|
      t.string :url
      t.references :user, foreign_key: true, null: true
      t.boolean :private, default: true
      t.float :width, null: false
      t.float :height, null: false

      t.timestamps
    end

    add_reference :canvases, :template, foreign_key: true, null: true
  end
end
