class CanvasChannel < ApplicationCable::Channel

  def subscribed
    stream_from "canvas_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def draw(data)
    content = data['content']
    stroke = Stroke.new(content['stroke'])
    stroke.user = User.find_by(id: current_user)
    stroke.canvas = Canvas.find_by(id: content['canvas_id'])
    if stroke.save
      ActionCable.server.broadcast 'canvas_channel',
        stroke: stroke.as_json(except: [:user, :canvas, :created_at, :updated_at]),
        user: stroke.user.name,
        canvas: stroke.canvas.name,
        time: stroke.updated_at
    else
      puts "[ERROR] CanvasChannel.draw - error: #{stroke.errors.full_messages}"
    end  
  end

end
