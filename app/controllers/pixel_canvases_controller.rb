class PixelCanvasesController < ApplicationController
  def show
    canvas = PixelCanvas.find(params[:id])
    if canvas
      render status: :ok,
        json: canvas
    else
      head :not_found
    end
  end
end
