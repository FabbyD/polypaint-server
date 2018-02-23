class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.references :user, foreign_key: true
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
