class AddTemplateToCanvases < ActiveRecord::Migration[5.1]
  def change
    add_reference :canvases, :template, foreign_key: true, null: true
  end
end
