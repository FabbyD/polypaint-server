class AddThumbnailUpdatedAtToCanvases < ActiveRecord::Migration[5.1]
  def change
    add_column :canvases, :thumbnail_updated_at, :timestamp
  end
end
