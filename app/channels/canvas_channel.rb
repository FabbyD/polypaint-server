require 'base64'
require 'tempfile'

class CanvasChannel < ApplicationCable::Channel
  include CanvasHelper

  def subscribed
    stream_from "canvas_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def draw(data)
    content = data['content']
    stroke = Stroke.new(content['stroke'])
    stroke.user = User.find_by(id: current_user)
    stroke.canvas = Canvas.find_by(id: content['canvas_id'])
    puts "CanvasChannel.draw - stroke: #{stroke.inspect}"
    if stroke.save
      ActionCable.server.broadcast 'canvas_channel',
        stroke: stroke.as_json(except: [:user_id, :canvas_id, :created_at, :updated_at]),
        user: stroke.user.name,
        canvas: stroke.canvas.name,
        time: stroke.updated_at
    else
      puts "[ERROR] CanvasChannel.draw - error: #{stroke.errors.full_messages}"
    end  
  end

  def add_image(data)
    content = data['content']
    if (content['image'] != nil)
      encoded = split_base64 content['image']['data']
      decoded = Base64.decode64(encoded['data']) 
      filetype = encoded['filetype']
      file = Tempfile.new(['upload', ".#{filetype}"], Rails.root.join('tmp').to_s, :encoding => 'ascii-8bit')
      begin
        file.write(decoded)
        if file.size > 1.megabyte
          puts "CanvasChannel.add_image - file too large for upload: #{file.size}"
        else
          puts "CanvasChannel.add_image - uploading image of size: #{file.size}"
          obj = S3_BUCKET.object(File.basename(file.path))
          obj.upload_file(file.path)
          puts "CanvasChannel.add_image - uploaded to #{obj.public_url}"

          canvas_image = CanvasImage.new(image_params(content['image']))
          canvas_image.url = obj.public_url
          canvas_image.user = User.find_by(id: current_user)
          canvas_image.canvas = Canvas.find_by(id: content['canvas_id'])
          if canvas_image.save
            ActionCable.server.broadcast 'canvas_channel',
              canvas_image: canvas_image.as_json(except: [:user_id, :canvas_id, :created_at, :updated_at]),
              user: canvas_image.user.name,
              canvas: canvas_image.canvas.name,
              time: canvas_image.updated_at
          else
            puts "[ERROR] CanvasChannel.add_image - error: #{canvas_image.errors.full_messages}"
          end
        end
      ensure
        file.close
        file.unlink
      end
    end
  end

  private

  def image_params(image)
    return image.except('data')
  end

end
