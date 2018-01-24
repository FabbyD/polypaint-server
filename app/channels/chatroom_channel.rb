class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chatroom_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message(data)
    message = Message.new(content: data["content"])
    message.user = User.find_by(id: 2) # FIXME put actual user_id
    message.chatroom = Chatroom.find_by(id: 1) # FIXME put actual chatroom_id
    if message.save
      ActionCable.server.broadcast 'chatroom_channel',
        message: message.content,
        user: message.user
    else
      puts 'Failed to save message in database.'
    end
  end
end
