class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    room = params[:room]
    
    if room == "Waiting Room"
      stream_from get_stream_name
    else
      canvas = Canvas.find_by(id: room)
      if canvas
        stream_from get_stream_name
      else
        puts "[ERROR] ChatroomChannel.subscribed - could not find canvas with id #{params[:room]}"
      end
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message(data)
    room = params[:room]
    chatroom = nil
    if room == "Waiting Room"
      chatroom = Chatroom.find_by(name: room)
    else
      canvas = Canvas.find(params[:room])
      if canvas
        chatroom = canvas.chatroom
      else
        puts "[ERROR] ChatroomChannel.message - could not find canvas with id #{params[:room]}"
        return
      end
    end

    message = Message.new(content: data["content"])
    message.user = User.find_by(id: current_user)
    message.chatroom = chatroom
    if message.save
      ActionCable.server.broadcast get_stream_name,
        message: message.content,
        user: message.user.name,
        time: message.created_at
    else
      puts "[ERROR] ChatroomChannel.message - error: #{message.errors.full_messages}"
    end
  end

  private 

  def get_stream_name
    "chatroom_channel:#{params[:room]}"
  end
end
