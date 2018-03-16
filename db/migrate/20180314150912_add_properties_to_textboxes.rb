class AddPropertiesToTextboxes < ActiveRecord::Migration[5.1]
  def change
    add_column :textboxes, :width, :float
    add_column :textboxes, :height, :float
    add_column :textboxes, :color, :string, limit: 6
    add_column :textboxes, :font_size, :float

		reversible do |dir|
      dir.up do
        # add a CHECK constraint
        execute <<-SQL
          ALTER TABLE textboxes
            ADD CONSTRAINT colorchk
              CHECK (char_length(color) = 6 AND color ~ '^[0-9A-F]{6}$') NO INHERIT;
        SQL
      end
      dir.down do
        execute <<-SQL
          ALTER TABLE textboxes
            DROP CONSTRAINT colorchk
        SQL
      end
    end
  end
end
