class CreateTemplates < ActiveRecord::Migration[5.1]
  def change
    create_table :templates do |t|
      t.string :url
      t.references :user, foreign_key: true
      t.boolean :private

      t.timestamps
    end
  end
end
