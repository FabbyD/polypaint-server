module CanvasHelper
  def split_base64(data)
    matches = /data:.*\/(.*);base64,(.*)/.match(data)
    return {
      'filetype' => matches[1],
      'data' => matches[2]
    }
  end
end
