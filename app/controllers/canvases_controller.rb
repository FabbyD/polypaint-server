class CanvasesController < ApplicationController
  def show
    canvas = Canvas.find_by(id: params[:id])
    if canvas
      jcanvas = canvas.as_json()
      layers = canvas.layers
      jcanvas["layers"] = layers.map do |layer|
        jlayer = layer.as_json()
        jlayer["strokes"] = layer.strokes
        jlayer["images"] = layer.canvas_images
        jlayer["textboxes"] = layer.textboxes
        jlayer
      end
      render status: :ok,
        json: { canvas: jcanvas }.to_json
    else
      render status: :not_found
    end
  end

  def index
    canvases = Canvas
      .select('canvases.id, canvases.name, canvases.description, canvases.private, canvases.protected, canvases.width, canvases.height, users.name as user_name, canvases.created_at, canvases.updated_at')
      .joins(:user)
      .where(private: false)
    render status: :ok,
      json: { canvases: canvases }.to_json
  end

  def indexByUser
    canvases = Canvas
      .select('canvases.id, canvases.name, canvases.description, canvases.private, canvases.protected, canvases.width, canvases.height, users.name as user_name, canvases.created_at, canvases.updated_at')
      .joins(:user)
      .where('users.name = ?', params[:user_name])

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
end
