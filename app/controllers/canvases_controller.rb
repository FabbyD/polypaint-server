class CanvasesController < ApplicationController
  def get
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
end
