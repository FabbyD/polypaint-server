class AddPrivacyToCanvases < ActiveRecord::Migration[5.1]
  def change
    add_column :canvases, :private, :boolean, default: true
    add_column :canvases, :protected, :boolean, default: false
    add_column :canvases, :password_digest, :string, default: ''
  end
end
