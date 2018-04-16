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

  def create
    canvas = PixelCanvas.new(params.require(:canvas).permit(:name, :description, :width, :height, :private, :protected, :password))
    canvas.user = User.find_by(name: params[:current_user])

    if canvas.save
      # Create chatroom
      chatroom = Chatroom.new()
      chatroom.pixel_canvas = canvas
      chatroom.name = SecureRandom.uuid
      if not chatroom.save
        puts "[ERROR] PixelCanvasesController.create - chatroom error: #{chatroom.errors.full_messages}"
      end

      render status: :ok,
        json: { pixel_canvas: canvas }
    else
      puts "[ERROR] PixelCanvasesController.create - error: #{canvas.errors.full_messages}"
      render status: :bad_request,
        json: { errors: canvas.errors.full_messages }
    end
  end

  def update
    canvas = PixelCanvas.find_by(id: params[:id])
    if canvas
      canvas.update(params.require(:canvas).permit(:name, :description, :height, :width, :password, :private, :protected))
      if canvas.errors.full_messages.size > 0
        puts "[ERROR] PixelCanvasesController.update - error: #{canvas.errors.full_messages}"
        render status: :bad_request,
          json: { errors: canvas.errors.full_messages }
      else
        render status: :ok,
          json: { canvas: canvas }
      end
    else
    end
  end

  def authenticate
    canvas = PixelCanvas.find_by(id: params[:canvas][:id])
    if canvas && canvas.authenticate(params[:canvas][:password])
      head :ok
    else
			head :unauthorized
    end
  end
end
