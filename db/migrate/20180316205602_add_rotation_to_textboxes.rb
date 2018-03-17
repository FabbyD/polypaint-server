class AddRotationToTextboxes < ActiveRecord::Migration[5.1]
  def change
    add_column :textboxes, :rotation, :float, default: 0
  end
end
