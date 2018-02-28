class CreateStrokes < ActiveRecord::Migration[5.1]
  def change
    create_table :strokes do |t|
      t.integer :points_x, array: true, null: false, default: []
      t.integer :points_y, array: true, null: false, default: []
      t.string :color, limit: 6, null: false
      t.integer :width, null: false
      t.integer :height, null: false
      t.integer :shape, null: false
      t.references :user, foreign_key: true
      t.references :image, foreign_key: true

      t.timestamps
    end

		reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE strokes
            ADD CONSTRAINT colorchk
              CHECK (char_length(color) = 6 AND color ~ '^[0-9A-F]{6}$') NO INHERIT;
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE strokes
            DROP CONSTRAINT colorchk
        SQL
      end
    end
  end
end
