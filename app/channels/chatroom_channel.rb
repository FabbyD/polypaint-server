class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    canvas = Canvas.find_by(id: params[:room])
    if canvas
      stream_from get_stream_name
    else
      puts "ChatroomChannel.subscribed - could not find canvas with id #{params[:room]}"
    end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message(data)
    canvas = Canvas.find(params[:room])
    if not canvas
      puts "ChatroomChannel.message - could not find canvas with id #{params[:room]}"
      return
    end

    message = Message.new(content: data["content"])
    message.user = User.find_by(id: current_user)
    message.chatroom = canvas.chatroom
    if message.save
      ActionCable.server.broadcast get_stream_name,
        message: message.content,
        user: message.user.name,
        time: message.created_at
    else
      puts "ChatroomChannel.message - error: #{message.errors.full_messages}"
    end
  end

  private 

  def get_stream_name
    "chatroom_channel:#{params[:room]}"
  end
end
