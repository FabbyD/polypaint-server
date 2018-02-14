class UserList
  @@prefix = 'user_'

  def self.add(user_id)
    puts "UserList.add - user_id: #{user_id}"
    Redis.current.set("#{@@prefix}#{user_id}", Time.now)
    self.update_expiry(user_id)
  end

  def self.remove(user_id)
    puts "UserList.remove - user_id: #{user_id}"
    Redis.current.del("#{@@prefix}#{user_id}")
  end

  def self.exists?(user_id)
    return Redis.current.exists("#{@@prefix}#{user_id}")
  end
  
  def self.update_expiry(user_id)
    Redis.current.expire("#{@@prefix}#{user_id}", 900) # 15 minutes
  end
end
