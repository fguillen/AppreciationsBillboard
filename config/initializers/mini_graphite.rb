require "mini_graphite"

Dalia::MiniGraphite.config({
  :graphite_host => APP_CONFIG[:mini_graphite]["graphite_host"],
  :graphite_port => APP_CONFIG[:mini_graphite]["graphite_port"],
  :statsd_host => APP_CONFIG[:mini_graphite]["statsd_host"],
  :statsd_port => APP_CONFIG[:mini_graphite]["statsd_port"],
  :mock_mode => APP_CONFIG[:mini_graphite]["mock_mode"],
  :debug_mode => APP_CONFIG[:mini_graphite]["debug_mode"]
})
