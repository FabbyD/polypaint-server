class ChatroomsController < ApplicationController
  def index
  end

  def show
    chatroom = nil
    if params[:id] == "Waiting Room"
      chatroom = Chatroom.find_by(name: params[:id])
    elsif params[:id].starts_with?("pixel:")
      id = params[:id][6..-1]
      canvas = PixelCanvas.find(id)
      if canvas
        chatroom = canvas.chatroom
      end
    else
      canvas = Canvas.find(params[:id])
      if canvas
        chatroom = canvas.chatroom
      end
    end

    if chatroom
      render status: :ok,
        json: {
          chatroom: {
            'messages': chatroom.messages.limit(50).order('id desc').reverse().map do |message|
              {
                message: message.content,
                user: message.user.name,
                time: message.updated_at
              }
            end
          }
        }
    else
      head :not_found
    end
  end
end

