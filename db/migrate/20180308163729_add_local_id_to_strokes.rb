class AddLocalIdToStrokes < ActiveRecord::Migration[5.1]
  def change
    add_column :strokes, :local_id, :string
  end
end
