require 'securerandom'

class CanvasesController < ApplicationController
  include FileUploadHelper

  def create
    permitted = params.require(:canvas).permit(:name, :description, :width, :height, :private, :protected, :password, :template_id, :layers)
    canvas = Canvas.new(permitted.except(:layers, "layers"))
    canvas.user = User.find_by(name: params[:current_user])

    if canvas.save
      # Create first default layer
      puts "Creating default layer"
      layer = Layer.new(uuid: "layer:#{SecureRandom.uuid}", index: 0)
      layer.canvas = canvas
      if not layer.save
        puts "[ERROR] CanvasesController.create - layer error: #{layer.errors.full_messages}"
      end

      # Create chatroom
      chatroom = Chatroom.new()
      chatroom.canvas = canvas
      chatroom.name = SecureRandom.uuid
      if not chatroom.save
        puts "[ERROR] CanvasesController.create - chatroom error: #{chatroom.errors.full_messages}"
      end

      render status: :ok,
        json: { canvas: canvas }
    else
      puts "[ERROR] CanvasesController.create - error: #{canvas.errors.full_messages}"
      render status: :bad_request,
        json: { errors: canvas.errors.full_messages }
    end
  end

  def push
    permitted = params.require(:canvas).permit(:name, :description, :width, :height, :private, :protected, :password, :template_id, :user_id,
                                              layers: [ :uuid, :index,
                                                       { strokes: [ { points_x: [] }, { points_y: [] }, :color, :width, :height, :shape, :local_id, :layer_uuid] },
                                                       { images: [ :local_id, :pos_x, :pos_y, :width, :height, :layer_uuid, :data ] },
                                                       { textboxes: [ :local_id, :layer_uuid, :pos_x, :pos_y, :width, :height, :color, :font_size, :content ] }
                                                      ])
    
    user = User.find_by(name: params[:current_user])
    canvas = Canvas.new(permitted.except(:layers, "layers"))
    canvas.user = user

    if canvas.save
      layers = permitted[:layers] || permitted["layers"]
      for jlayer in layers
        layer = Layer.new(jlayer.except("strokes", "images", "textboxes"))
        layer.canvas = canvas
        if layer.save
          for jstroke in jlayer["strokes"]
            stroke = Stroke.new(jstroke.except('layer_uuid'))
            stroke.layer = layer
            stroke.user = user
            stroke.editor = user
            stroke.save
          end
          for jtextbox in jlayer["textboxes"]
            textbox = Textbox.new(jtextbox.except('layer_uuid'))
            textbox.layer = layer
            textbox.editor = user
            textbox.save
          end
          for jimage in jlayer["images"]
            image = CanvasImage.new(jimage.except('data', 'layer_uuid'))
            image.layer = layer
            image.user = user
            url = upload_image(jimage['data'], path: 'canvas_images/')
            image.url = url
            image.save
          end
        else
          puts "[ERROR] CanvasesController.push - layer error: #{layer.errors.full_messages}"
        end
      end

      # Create chatroom
      chatroom = Chatroom.new()
      chatroom.canvas = canvas
      chatroom.name = SecureRandom.uuid
      if not chatroom.save
        puts "[ERROR] CanvasesController.push - chatroom error: #{chatroom.errors.full_messages}"
      end

      render status: :ok,
        json: { canvas: canvas }
    end
  end

  def update
    canvas = Canvas.find_by(id: params[:id])
    if canvas
      canvas.update(params.require(:canvas).permit(:name, :description, :height, :width, :password, :private, :protected))
      if canvas.errors.full_messages.size > 0
        puts "[ERROR] CanvasesController.update - error: #{canvas.errors.full_messages}"
        render status: :bad_request,
          json: { errors: canvas.errors.full_messages }
      else
        render status: :ok,
          json: { canvas: canvas }
      end
    else
    end
  end

  def show
    canvas = canvasSelect
      .includes(layers: [:strokes, :canvas_images, :textboxes])
      .find(params[:id])
    if canvas
      jcanvas = canvas.as_json()
      puts jcanvas
      if canvas.template
        jcanvas["template_url"] = canvas.template.url
      end
      jcanvas["layers"] = canvas.layers.order('layers.index ASC').map do |layer|
        jlayer = layer.as_json()
        jlayer["strokes"] = layer.strokes.select('*, strokes.id, users.name as editor_name').order('strokes.created_at ASC').joins(:editor)
        jlayer["images"] = layer.canvas_images.order('canvas_images.created_at ASC')
        jlayer["textboxes"] = layer.textboxes.order('textboxes.created_at ASC')
        jlayer
      end
      puts jcanvas
      render status: :ok,
        json: { canvas: jcanvas }
    else
      render status: :not_found
    end
  end

  def index
    canvases = canvasSelect.where(private: false)
    pixel_canvases = pixelCanvasSelect.where(private: false)
    render status: :ok,
      json: {
        canvases: canvases,
        pixel_canvases: pixel_canvases
      }.to_json
  end

  def indexByUser
    canvases = canvasSelect.where('users.name = ?', params[:user_name])
    pixel_canvases = pixelCanvasSelect.where('users.name = ?', params[:user_name])
    if params[:current_user] != params[:user_name]
      canvases = canvases.where(private: false)
      pixel_canvases = pixel_canvases.where(private: false)
    end

    render status: :ok,
      json: {
        canvases: canvases,
         pixel_canvases: pixel_canvases
      }.to_json
  end

  def authenticate
    canvas = Canvas.find_by(id: params[:canvas][:id])
    if canvas && canvas.authenticate(params[:canvas][:password])
      head :ok
    else
			head :unauthorized
    end
  end

  private

  def canvasSelect
    Canvas.select('canvases.id, canvases.name, canvases.description, canvases.thumbnail,
                  canvases.private, canvases.protected, canvases.width, canvases.height,
                  users.name as user_name, canvases.template_id, canvases.created_at, canvases.updated_at')
      .joins(:user)
  end

  def pixelCanvasSelect
    PixelCanvas.select('pixel_canvases.id, pixel_canvases.name, pixel_canvases.url, pixel_canvases.private,
                        pixel_canvases.protected, pixel_canvases.width, pixel_canvases.height, users.name as user_name,
                        pixel_canvases.created_at, pixel_canvases.updated_at')
      .joins(:user)
  end

  def saveLayer
  end

  def saveStroke
  end

  def saveImage(jimage, layer, user)
  end

  def saveTextBox
  end

end
