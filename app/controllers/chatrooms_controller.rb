class ChatroomsController < ApplicationController
  def index
  end

  def show
    chatroom = Chatroom.find(params[:id])
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
    end
  end
end

