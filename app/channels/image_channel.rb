class ImageChannel < ApplicationCable::Channel
  include ImageHelper

  def subscribed
    stream_from "image_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def draw(data)
    content = data['content']
    stroke = Stroke.new(content['stroke'])
    stroke.user = User.find_by(id: current_user)
    stroke.image = Image.find_by(id: content['image_id'])
    if stroke.save
      ActionCable.server.broadcast 'image_channel',
        stroke: process_stroke(stroke),
        user: stroke.user.name,
        time: stroke.created_at
    else
      puts "[ERROR] ImageChannel.draw - error: #{stroke.errors.full_messages}"
    end  
  end

end
