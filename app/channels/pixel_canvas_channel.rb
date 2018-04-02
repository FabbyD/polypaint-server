class PixelCanvasChannel < ApplicationCable::Channel
  def subscribed
    stream_from "pixel_canvas_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update_pixels(data)
    content = data['content']
    pixels_x = content['pixel_canvas']['pixels_x']
    pixels_y = content['pixel_canvas']['pixels_y']
    color = content['pixel_canvas']['color']
    id = content['pixel_canvas']['id']

    ActiveRecord::Base.logger.silence do
      canvas = PixelCanvas.find(id)
      if canvas
        pixels_x.zip(pixels_y).each do |x,y|
          index = y * canvas.height + x
          if index < canvas.height*canvas.width
            canvas.pixels[index] = color
          else
            puts "[ERROR] PixelCanvas.udpate_pixels - woops trying to update outside of grid"
          end
        end
        if canvas.save
          ActionCable.server.broadcast 'pixel_canvas_channel',
            action: 'update_pixels',
            pixel_canvas: content['pixel_canvas'],
            user: current_user.name,
            time: canvas.updated_at
        else
          puts "[ERROR] PixelCanvasChannel.add_pixels - errors: #{canvas.errors.full_messages}"
        end
      else
        puts "[ERROR] PixelCanvasChannel.add_pixels - could not find canvas"
      end
    end
  end
end
