class PixelCanvasChannel < ApplicationCable::Channel
  def subscribed
    stream_from "pixel_canvas_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def add_pixels(data)
    content = data['content']
    pixels = content['pixels']
    color = pixels['color']
    canvas_id = pixels['pixel_canvas_id']

    # delete previous pixels value
    Pixel.where(coord: pixels['coords']).delete_all

    # add new values
    # raw sql because rails does not do support batch inserts
    now = DateTime.now
    sql = "INSERT INTO pixels (coord, color, pixel_canvas_id, created_at, updated_at) VALUES "
    sql += pixels['coords'].map do |coord|
      "('#{coord}', '#{color}', '#{canvas_id}', '#{now}', '#{now}')"
    end.join(", ")
    sql += ';'
    ActiveRecord::Base.connection.execute(sql)

    #Pixel.transaction do
    #  pixels['coords'].each do |coord|
    #    Pixel.create(coord: coord, color: color, pixel_canvas_id: canvas_id)
    #  end
    #end

  end

  def remove_pixels(data)
  end
end
