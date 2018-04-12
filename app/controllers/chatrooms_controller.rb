class ChatroomsController < ApplicationController
  def index
  end

  def show
    canvas = Canvas.find(params[:id])
    if canvas and canvas.chatroom
      render status: :ok,
        json: {
          chatroom: {
            'messages': canvas.chatroom.messages.limit(50).order('id desc').reverse().map do |message|
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

