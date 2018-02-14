#config/initializers/redis.rb
require 'redis'

Redis.current = Redis.new(url: ENV["REDIS_URL"])
