class CanvasesController < ApplicationController
  def show
    canvas = canvasSelect
      .includes(layers: [:strokes, :canvas_images, :textboxes])
      .find(params[:id])
    if canvas
      jcanvas = canvas.as_json()
      jcanvas["layers"] = canvas.layers.map do |layer|
        jlayer = layer.as_json()
        jlayer["strokes"] = layer.strokes
        jlayer["images"] = layer.canvas_images
        jlayer["textboxes"] = layer.textboxes
        jlayer
      end
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
    if params[:current_user] != params[:user_name]
      canvases = canvases.where(private: false)
    end

    render status: :ok,
      json: { canvases: canvases }.to_json
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
                  users.name as user_name, canvases.created_at, canvases.updated_at')
      .joins(:user)
  end

  def pixelCanvasSelect
    PixelCanvas.select('pixel_canvases.id, pixel_canvases.name, pixel_canvases.url, pixel_canvases.private,
                        pixel_canvases.protected, pixel_canvases.width, pixel_canvases.height, users.name as user_name,
                        pixel_canvases.created_at, pixel_canvases.updated_at')
      .joins(:user)
  end
end
