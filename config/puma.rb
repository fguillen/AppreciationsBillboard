threads_count = ENV.fetch("RAILS_MAX_THREADS") { 2 }.to_i
threads threads_count, threads_count

bind 'unix:///var/run/puma/my_app.sock'

environment ENV.fetch("RAILS_ENV") { "development" }
workers ENV.fetch("WEB_CONCURRENCY") { %x(grep -c processor /proc/cpuinfo) }

pidfile '/var/run/puma/puma.pid'
stdout_redirect '/var/log/puma/puma.log', '/var/log/puma/puma.log', true
daemonize false
