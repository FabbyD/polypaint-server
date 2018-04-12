class ChangeColorCheckConstraint < ActiveRecord::Migration[5.1]
  def change
    
    change_column :strokes, :color, :string, limit: 8
    change_column :textboxes, :color, :string, limit: 8

		reversible do |dir|
      dir.up do
        # remove previous CHECK constraint and correct it
        execute <<-SQL
          ALTER TABLE strokes
            DROP CONSTRAINT colorchk;
          ALTER TABLE strokes
            ADD CONSTRAINT colorchk
              CHECK (char_length(color) = 8 AND color ~ '^[0-9A-Fa-f]{8}$') NO INHERIT;

          ALTER TABLE textboxes
            DROP CONSTRAINT colorchk;
          ALTER TABLE textboxes
            ADD CONSTRAINT colorchk
              CHECK (char_length(color) = 8 AND color ~ '^[0-9A-Fa-f]{8}$') NO INHERIT;
        SQL
      end
      dir.down do
        # restore previous check constraint
        execute <<-SQL
          ALTER TABLE strokes
            DROP CONSTRAINT colorchk;
          ALTER TABLE strokes
            ADD CONSTRAINT colorchk
              CHECK (char_length(color) = 6 AND color ~ '^[0-9A-F]{6}$') NO INHERIT;

          ALTER TABLE textboxes
            DROP CONSTRAINT colorchk;
          ALTER TABLE textboxes
            ADD CONSTRAINT colorchk
              CHECK (char_length(color) = 6 AND color ~ '^[0-9A-F]{6}$') NO INHERIT;
        SQL
      end
    end
  end
end
