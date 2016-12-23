require 'redis'
require 'json'

$redis = ENV['host'] ? Redis.new(url: ENV['host']) : Redis.new
$host = $redis.client.host.split('.').first + '-' + $redis.client.port.to_s
