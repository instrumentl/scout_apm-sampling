require_relative "sampling/version"

require "scout_apm/sampling/railtie" if defined?(Rails::Railtie)
require "scout_apm/sampling/sidekiq/server_middleware" if defined?(::Sidekiq)
