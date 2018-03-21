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

  def add_canvas(data)
    content = data['content']
    user = User.find_by(id: current_user)
    canvas = Canvas.new(content['canvas'])
    canvas.user = user
    if canvas.save
      ActionCable.server.broadcast 'canvas_channel',
        action: 'add_canvas',
        canvas: canvas.as_json(except: [:user_id, :created_at, :updated_at]),
        user: user.name,
        time: canvas.updated_at
    else
      puts "[ERROR] CanvasChannel.add_canvas - error: #{canvas.errors.full_messages}"
    end
  end

  def add_layer(data)
    content = data['content']
    user = User.find_by(id: current_user)
    layer = Layer.new(content['layer'])
    layer.canvas = Canvas.find_by(id: content['canvas_id'])
    puts "CanvasChannel.add_layer - layer: #{layer.inspect}"
    if layer.save
      ActionCable.server.broadcast 'canvas_channel',
        action: 'add_layer',
        layer: layer.as_json(except: [:canvas_id, :created_at, :updated_at]),
        canvas_name: layer.canvas.name,
        user: user.name,
        time: layer.updated_at
    else
      puts "[ERROR] CanvasChannel.add_layer - error: #{stroke.errors.full_messages}"
    end
  end

  def update_layer(data)
    content = data['content']
    user = User.find_by(id: current_user)
    layer = Layer.find_by(uuid: content['layer']['uuid'])
    puts "CanvasChannel.update_layer - layer: #{layer.inspect}"
    if layer
      # shift other layers and assing new index
      newIndex = content['layer']['index']
      layers = []
      if layer.index < newIndex
        layers = Layer.where("index > ? AND index <= ?", layer.index, newIndex)
      else
        layers = Layer.where("index >= ? AND index < ?", newIndex, layer.index)
      end
      incr = newIndex > layer.index ? -1 : 1
      for l in layers
        l.index += incr
        l.save
      end
      layer.index = newIndex
      layer.save

      ActionCable.server.broadcast 'canvas_channel',
        action: 'update_layer',
        layer: layer.as_json(except: [:canvas_id, :created_at, :updated_at]),
        canvas_name: layer.canvas.name,
        user: user.name,
        time: layer.updated_at
    else
      puts "[WARNING] CanvasChannel.move_layer - could not find the layer to move "
    end
  end

  def remove_layer(data)
    content = data['content']
    user = User.find_by(id: current_user)
    layer = Layer.find_by(uuid: content['layer']['uuid'])
    if layer
      layer.destroy
      ActionCable.server.broadcast 'canvas_channel',
        action: 'remove_layer',
        layer: layer.as_json(except: [:canvas_id, :created_at, :updated_at]),
        canvas_name: layer.canvas.name,
        user: user.name,
        time: layer.updated_at
    end
  end

  def add_strokes(data)
    content = data['content']
    user = User.find_by(id: current_user)
    jstrokes = content['strokes']
    jstrokes = jstrokes.map do |jstroke| 
      layer = Layer.find_by(uuid: jstroke['layer_uuid'])
      jstroke["user_id"] = user.id
      jstroke["editor_id"] = user.id
      jstroke["layer_id"] = layer.id
      jstroke.except("layer_uuid")
    end
    strokes = Stroke.create(jstrokes)

    valid = true
    errors = []
    for stroke in strokes
      if stroke.errors.count > 0
        valid = false
        errors.append(stroke.errors.full_messages)
      end
    end

    if valid
      jstrokes = strokes.map do |s|
        jstroke = s.as_json(except: ['user_id', 'editor_id', 'layer_id', 'created_at', 'updated_at'])
        jstroke['layer_uuid'] = s.layer.uuid
        jstroke
      end
      ActionCable.server.broadcast 'canvas_channel',
        action: 'add_strokes',
        strokes: jstrokes,
        user: user.name,
        editor: user.name,
        canvas_name: strokes[0].layer.canvas.name,
        time: strokes[-1].updated_at
    else
      puts "[ERROR] CanvasChannel.add_strokes - error: #{errors}"
    end
  end

  def add_stroke(data)
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
        canvas_name: stroke.canvas.name,
        time: stroke.updated_at
    else
      puts "[ERROR] CanvasChannel.draw - error: #{stroke.errors.full_messages}"
    end  
  end

  def update_stroke(data)
    content = data['content']
    stroke = Stroke.find_by(id: content['stroke']['id'])
    if stroke
      stroke.editor = User.find_by(id: current_user)
      stroke.update(content['stroke'])
      ActionCable.server.broadcast 'canvas_channel',
        action: 'modify_stroke',
        stroke: stroke.as_json(except: [:user_id, :canvas_id, :created_at, :updated_at]),
        user: stroke.editor.name,
        canvas_name: stroke.canvas.name,
        time: stroke.updated_at
    end
  end

  def update_strokes(data)
    content = data['content']
    user = User.find_by(id: current_user)
    jstrokes = content['strokes']
    
    ids = {}
    for jstroke in jstrokes
      layer = Layer.find_by(uuid: jstroke['layer_uuid'])
      jstroke['user_id'] = user.id
      jstroke['editor_id'] = user.id
      jstroke['layer_id'] = layer.id
      ids[jstroke['id']] = jstroke.except("layer_uuid")
    end

    strokes = Stroke.update(ids.keys, ids.values)
    jstrokes = strokes.map do |s|
        jstroke = s.as_json(except: ['user_id', 'editor_id', 'layer_id', 'created_at', 'updated_at'])
        jstroke['layer_uuid'] = s.layer.uuid
        jstroke
    end
    ActionCable.server.broadcast 'canvas_channel',
      action: 'update_strokes',
      strokes: jstrokes,
      user: user.name,
      editor: user.name,
      canvas_name: strokes[0].layer.canvas.name,
      time: strokes[-1].updated_at
  end

  def remove_stroke(data)
    content = data['content']
    stroke = Stroke.find_by(id: content['stroke']['id'])
    if stroke
      stroke.destroy
      jstroke = stroke.as_json(except: ['user_id', 'editor_id', 'layer_id', 'created_at', 'updated_at'])
      jstroke['layer_uuid'] = stroke.layer.uuid
      ActionCable.server.broadcast 'canvas_channel',
        action: 'remove_stroke',
        stroke: jstroke,
        user: stroke.user.name,
        editor: User.find_by(id: current_user).name,
        canvas_name: stroke.layer.canvas.name,
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

        canvas_image = CanvasImage.new(content['image'].except('data', 'layer_uuid'))
        canvas_image.url = obj.public_url
        canvas_image.user = User.find_by(id: current_user)
        canvas_image.layer = Layer.find_by(uuid: content['image']['layer_uuid'])
        if canvas_image.save
          jimage = canvas_image.as_json(except: [:user_id, :layer_id, :created_at, :updated_at])
          jimage['layer_uuid'] = canvas_image.layer.uuid
          ActionCable.server.broadcast 'canvas_channel',
            action: 'add_image',
            image: jimage,
            user: canvas_image.user.name,
            canvas_name: canvas_image.layer.canvas.name,
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

  def update_image(data)
    content = data['content']
    canvas_image = CanvasImage.find_by(id: content['image']['id'])
    if canvas_image
      canvas_image.user = User.find_by(id: current_user)
      canvas_image.update(content['image'])
      jimage = canvas_image.as_json(except: [:user_id, :layer_id, :created_at, :updated_at])
      jimage['layer_uuid'] = canvas_image.layer.uuid
      ActionCable.server.broadcast 'canvas_channel',
        action: 'update_image',
        image: jimage,
        user: canvas_image.user.name,
        canvas_name: canvas_image.layer.canvas.name,
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
    jimage = canvas_image.as_json(except: [:user_id, :layer_id, :created_at, :updated_at])
    jimage['layer_uuid'] = canvas_image.layer.uuid
    ActionCable.server.broadcast 'canvas_channel',
      action: 'remove_image',
      image: jimage,
      user: User.find_by(id: current_user).name,
      canvas_name: canvas_image.layer.canvas.name,
      time: canvas_image.updated_at
  end

  def add_textbox(data)
    content = data['content']
    # Make sure to save text in LF format
    content['textbox']['content'].gsub!("\r\n", "\n")
    user = User.find_by(id: current_user)
    textbox = Textbox.new(content['textbox'].except('layer_uuid'))
    textbox.editor = user
    textbox.layer = Layer.find_by(uuid: content['textbox']['layer_uuid'])
    puts "CanvasChannel.add_textbox - textbox: #{textbox.inspect}"
    if textbox.save
      jtextbox = textbox.as_json(except: [:editor_id, :layer_id, :created_at, :updated_at])
      jtextbox["layer_uuid"] = textbox.layer.uuid
      ActionCable.server.broadcast 'canvas_channel',
        action: 'add_textbox',
        textbox: jtextbox,
        user: textbox.editor.name,
        canvas_name: textbox.layer.canvas.name,
        time: textbox.updated_at
    else
      puts "[ERROR] CanvasChannel.add_textbox - error: #{textbox.errors.full_messages}"
    end  
    
  end

  def update_textbox(data)
    content = data['content']
    # Make sure to save text in LF format
    if content['textbox'].key? 'content'
      content['textbox']['content'].gsub!("\r\n", "\n")
    end
    textbox = Textbox.find_by(id: content['textbox']['id'])
    if textbox
      textbox.editor = User.find_by(id: current_user)
      if (content['textbox'].key? 'layer_uuid') 
        textbox.layer = Layer.find_by(uuid: content['textbox']['layer_uuid'])
      end
      textbox.update(content['textbox'].except('layer_uuid'))
      if textbox.errors.size > 0
        puts "[ERROR] CanvasChannel.update_textbox - error: #{textbox.errors.full_messages}"
      else
        jtextbox = textbox.as_json(except: [:editor_id, :layer_id, :created_at, :updated_at])
        jtextbox["layer_uuid"] = textbox.layer.uuid
        ActionCable.server.broadcast 'canvas_channel',
          action: 'update_textbox',
          textbox: jtextbox,
          user: textbox.editor.name,
          canvas_name: textbox.layer.canvas.name,
          time: textbox.updated_at
      end
    end
  end

  def remove_textbox(data)
    content = data['content']
    textbox = Textbox.find_by(id: content['textbox']['id'])
    if textbox
      textbox.destroy
      jtextbox = textbox.as_json(except: [:editor_id, :layer_id, :created_at, :updated_at])
      jtextbox["layer_uuid"] = textbox.layer.uuid
      ActionCable.server.broadcast 'canvas_channel',
        action: 'remove_textbox',
        textbox: jtextbox,
        user: User.find_by(id: current_user).name,
        canvas_name: textbox.layer.canvas.name,
        time: textbox.updated_at
    end
  end

  def update_canvas(data)
    content = data['content']
    canvas = Canvas.find_by(id: content['canvas']['id'])
    if canvas
      canvas.update(content['canvas'])
      ActionCable.server.broadcast 'canvas_channel',
        action: 'update_canvas',
        canvas: canvas.as_json(except: [:user_id, :created_at, :updated_at]),
        user: User.find_by(id: current_user).name,
        time: canvas.updated_at
    end
  end

  private

  def get_s3_path(url)
    root = "https://#{S3_BUCKET.name}.s3.#{ENV['AWS_REGION']}.amazonaws.com/"
    url.match("^" + root + "(.*)$")[1]
  end

end
