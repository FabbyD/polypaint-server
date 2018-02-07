class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chatroom_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message(data)
    message = Message.new(content: data["content"])
    message.user = User.find_by(id: current_user)
    message.chatroom = Chatroom.find_by(id: 1) # FIXME take room from user
    if message.save
      ActionCable.server.broadcast 'chatroom_channel',
        message: message.content,
        user: message.user.name,
        time: message.created_at
    else
      puts "Failed to save message in database: #{message.errors.full_messages}"
    end
  end
end
