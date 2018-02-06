class ChatroomChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chatroom_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def message(data)
    #message = Message.new(content: data["content"])
    #message.user = User.find_by(id: current_user)
    #message.chatroom = Chatroom.find_by(id: 1) # FIXME take id in session
    #if message.save
      ActionCable.server.broadcast 'chatroom_channel',
        message: data["content"], # FIXME message.content
        user: 'Pablo' # FIXME message.user
        time: DateTime.now # FIXME message.date_created
    #else
    #  puts "Failed to save message in database: #{message.errors.full_messages}"
    #end
  end
end
