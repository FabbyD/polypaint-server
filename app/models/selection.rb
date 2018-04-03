class Selection
  attr_reader :user_id

  def initialize(user_id, strokes: nil, images: nil, textboxes: nil)
    @user_id = user_id
    if strokes
      self.strokes = strokes
    end
    if images
      self.images = images
    end
    if textboxes
      self.textboxes = textboxes
    end
  end

  def strokes
    get_members("strokes")
  end

  def strokes=(value)
    set_members("strokes", value)
  end

  def images
    get_members("images")
  end

  def images=(value)
    set_members("images", value)
  end

  def textboxes
    get_members("textboxes")
  end

  def textboxes=(value)
    set_members("textboxes", value)
  end

  def clear
    for key in Redis.current.keys("selected_*:#{user_id}") do
      Redis.current.del(key)
    end
  end

  private

  def get_members(element)
    Redis.current.smembers("selected_#{element}:#{user_id}")
  end

  def set_members(element, members)
    Redis.current.del("selected_#{element}:#{user_id}")
    if members.size > 0
      Redis.current.sadd("selected_#{element}:#{user_id}", members)
    end
  end
end
