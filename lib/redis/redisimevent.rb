require 'redis'

REDIS_OPTIONS = {
 #'host' => '10.0.1.39'
 'host' => 'localhost'
}

class RedisimEvent

  def initialize
    @redisc ||= Redis.new :host => REDIS_OPTIONS['host']
    @db_zero = 0
    @db_account = 5
    @primarykey = 'primary-key'
  end

  def get_key
    ['ios','android','java','python','ruby'].sample
  end

  def get_primary_key
    @redisc.select @db_account
    backvalue = @redisc.get @primarykey
    # this works because nil.to_i = 0
    value = backvalue.to_i + 1
    @redisc.set @primarykey, value
    value
  end

  def run
    for i in 1..10
      puts get_primary_key
    end
  end

end

rse = RedisimEvent.new
rse.run
