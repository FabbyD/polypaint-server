class CanvasChannel < ApplicationCable::Channel
  def subscribed
    stream_from "canvas_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def draw(data)
    puts data["content"]
  end
end
