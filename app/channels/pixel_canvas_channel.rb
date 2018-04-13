class PixelCanvasChannel < ApplicationCable::Channel
  include CanvasHelper

  def subscribed
    id = params[:room]
    canvas = PixelCanvas.find_by(id: params[:room])
    if canvas
      stream_from get_stream_name(canvas)
      stream_from "pixel_canvas_channel"
    else
      puts "[ERROR] PixelCanvasChannel.subscribed - could not get canvas id #{params[:room]}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def update_pixels(data)
    content = data['content']
    canvas = PixelCanvas.find(content['pixel_canvas']['id'])
    if canvas
      if canvas.url and canvas.url != ''
        path = get_s3_path(canvas.url)
        if path
          puts "PixelCanvasChannel.update_pixels - deleting previous bitmap"
          S3_BUCKET.object(path).delete
        end
      end
      #url = upload_image(content['pixel_canvas']['bitmap'], path: 'pixel-canvases/', filename: "pixel-canvas-#{canvas.id}.png")
      if true #canvas.update(url: url)
        ActionCable.server.broadcast get_stream_name(canvas),
          action: 'update_pixels',
          pixel_canvas: content['pixel_canvas'].except(['bitmap']),
          user: current_user.name,
          time: canvas.updated_at
      else
        puts "[ERROR] PixelCanvasChannel.add_pixels - errors: #{canvas.errors.full_messages}"
      end
    else
      puts "[ERROR] PixelCanvasChannel.add_pixels - could not find canvas"
    end
  end

  private 

  def get_stream_name(canvas)
    "pixel_canvas_channel:#{canvas.id}"
  end
end
