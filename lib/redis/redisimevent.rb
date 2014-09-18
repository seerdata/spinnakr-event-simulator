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

  def get_project
    ['1','2','3'].sample
  end

  def get_dimension
    'job-skills'
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
    value.to_s
  end

  def build_hash_key
    project = get_project
    dimension = get_dimension
    key = get_key
    primarykey = get_primary_key
    project + ':' + dimension + ':' + key + ':' + primarykey
  end

  def run
    @redisc.select @db_account
    for i in 1..10
      key = build_hash_key
      @redisc.hset key, 'account_id', @db_account.to_s
    end
  end

end

rse = RedisimEvent.new
rse.run
