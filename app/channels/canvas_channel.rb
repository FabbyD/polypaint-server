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
    user = User.find_by(id: current_user)
    stroke = Stroke.new(content['stroke'])
    stroke.user = user
    stroke.editor = user
    stroke.canvas = Canvas.find_by(id: content['canvas_id'])
    puts "CanvasChannel.draw - stroke: #{stroke.inspect}"
    if stroke.save
      ActionCable.server.broadcast 'canvas_channel',
        action: 'draw',
        stroke: stroke.as_json(except: [:user_id, :editor_id, :canvas_id, :created_at, :updated_at]),
        user: stroke.user.name,
        editor: stroke.editor.name,
        canvas: stroke.canvas.name,
        time: stroke.updated_at
    else
      puts "[ERROR] CanvasChannel.draw - error: #{stroke.errors.full_messages}"
    end  
  end

  def modify_stroke(data)
    content = data['content']
    stroke = Stroke.find_by(id: content['stroke']['id'])
    if stroke
      stroke.editor = User.find_by(id: current_user)
      stroke.update(content['stroke'])
      ActionCable.server.broadcast 'canvas_channel',
        action: 'modify_stroke',
        stroke: stroke.as_json(except: [:user_id, :canvas_id, :created_at, :updated_at]),
        user: User.find_by(id: current_user).name,
        canvas: stroke.canvas.name,
        time: stroke.updated_at
    end
  end

  def erase(data)
    content = data['content']
    stroke = Stroke.find_by(id: content['stroke']['id'])
    if stroke
      stroke.destroy
      ActionCable.server.broadcast 'canvas_channel',
        action: 'erase',
        stroke: stroke.as_json(except: [:user_id, :editor_id, :canvas_id, :created_at, :updated_at]),
        user: stroke.user.name,
        editor: User.find_by(id: current_user).name,
        canvas: stroke.canvas.name,
        time: stroke.updated_at
    end
  end

  def add_image(data)
    content = data['content']
    if (content['image'] == nil)
      return
    end

    encoded = split_base64 content['image']['data']
    decoded = Base64.decode64(encoded['data']) 
    filetype = encoded['filetype']
    file = Tempfile.new(['upload', ".#{filetype}"], Rails.root.join('tmp').to_s, :encoding => 'ascii-8bit')
    begin
      file.write(decoded)
      if file.size > 1.megabyte
        puts "[ERROR] CanvasChannel.add_image - file is too large for upload: #{file.size}"
      else
        puts "CanvasChannel.add_image - uploading image of size: #{file.size}"
        obj = S3_BUCKET.object(File.basename(file.path))
        obj.upload_file(file.path)
        puts "CanvasChannel.add_image - uploaded to #{obj.public_url}"

        canvas_image = CanvasImage.new(content['image'].except('data'))
        canvas_image.url = obj.public_url
        canvas_image.user = User.find_by(id: current_user)
        canvas_image.canvas = Canvas.find_by(id: content['canvas_id'])
        if canvas_image.save
          ActionCable.server.broadcast 'canvas_channel',
            action: 'add_image',
            image: canvas_image.as_json(except: [:user_id, :canvas_id, :created_at, :updated_at]),
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

  def modify_image(data)
    content = data['content']
    canvas_image = CanvasImage.find_by(id: content['image']['id'])
    if canvas_image
      canvas_image.user = User.find_by(id: current_user)
      canvas_image.update(content['image'])
      ActionCable.server.broadcast 'canvas_channel',
        action: 'modify_image',
        image: canvas_image.as_json(except: [:user_id, :canvas_id, :created_at, :updated_at]),
        user: canvas_image.user.name,
        canvas: canvas_image.canvas.name,
        time: canvas_image.updated_at
    end
  end

  def remove_image(data)
    content = data['content']
    if (content['image'] == nil)
      puts "[ERROR] CanvasChannel.remove_image - content incomplete"
      return
    end

    canvas_image = CanvasImage.find_by(id: content['image']['id'])
    if (canvas_image == nil)
      puts "[ERROR] CanvasChannel.remove_image - could not find image"
      return
    end

    obj = S3_BUCKET.object(get_s3_path(canvas_image.url))
    obj.delete
    canvas_image.destroy
    ActionCable.server.broadcast 'canvas_channel',
      action: 'remove_image',
      image: canvas_image.as_json(except: [:user_id, :canvas_id, :created_at, :updated_at]),
      user: User.find_by(id: current_user).name,
      canvas: canvas_image.canvas.name,
      time: canvas_image.updated_at
  end

  def add_textbox(data)
    content = data['content']
    # Make sure to save text in LF format
    content['textbox']['content'].gsub!("\r\n", "\n")
    user = User.find_by(id: current_user)
    textbox = Textbox.new(content['textbox'])
    textbox.editor = user
    textbox.canvas = Canvas.find_by(id: content['canvas_id'])
    puts "CanvasChannel.add_textbox - textbox: #{textbox.inspect}"
    if textbox.save
      ActionCable.server.broadcast 'canvas_channel',
        action: 'add_textbox',
        textbox: textbox.as_json(except: [:editor_id, :canvas_id, :created_at, :updated_at]),
        editor: textbox.editor.name,
        canvas: textbox.canvas.name,
        time: textbox.updated_at
    else
      puts "[ERROR] CanvasChannel.add_textbox - error: #{textbox.errors.full_messages}"
    end  
    
  end

  def modify_textbox(data)
    content = data['content']
    # Make sure to save text in LF format
    content['textbox']['content'].gsub!("\r\n", "\n")
    textbox = Textbox.find_by(id: content['textbox']['id'])
    if textbox
      textbox.editor = User.find_by(id: current_user)
      textbox.update(content['textbox'])
      ActionCable.server.broadcast 'canvas_channel',
        action: 'modify_textbox',
        textbox: textbox.as_json(except: [:editor_id, :canvas_id, :created_at, :updated_at]),
        user: textbox.editor.name,
        canvas: textbox.canvas.name,
        time: textbox.updated_at
    end
  end

  def remove_textbox(data)
    content = data['content']
    textbox = Textbox.find_by(id: content['textbox']['id'])
    if textbox
      textbox.destroy
      ActionCable.server.broadcast 'canvas_channel',
        action: 'remove_textbox',
        textbox: textbox.as_json(except: [:editor_id, :canvas_id, :created_at, :updated_at]),
        user: textbox.editor.name,
        canvas: textbox.canvas.name,
        time: textbox.updated_at
    end
  end

  private

  def get_s3_path(url)
    root = "https://#{S3_BUCKET.name}.s3.#{ENV['AWS_REGION']}.amazonaws.com/"
    url.match("^" + root + "(.*)$")[1]
  end

end
