# Change to match your CPU core count
workers 2

# Min and Max threads per worker
threads 1, 6

#app_dir = File.expand_path("../..", __FILE__)
shared_dir = "/home/rails/apps/pompeii/shared/tmp"

# Default to production
rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

# Set up socket location
bind "unix://#{shared_dir}/sockets/pompeii-puma.sock"

# Logging
stdout_redirect "/home/rails/apps/pompeii/shared/log/puma.stdout.log", "/home/rails/apps/pompeii/shared/log/puma.stderr.log", true

# Set master PID and state locations
pidfile "#{shared_dir}/pids/puma.pid"
state_path "#{shared_dir}/pids/puma.state"
activate_control_app

on_worker_boot do
  require "active_record"
  ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
  ActiveRecord::Base.establish_connection(YAML.load_file("/home/rails/apps/pompeii/current/config/database.yml")[rails_env])
end