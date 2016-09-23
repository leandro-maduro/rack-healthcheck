module Rack::Healthcheck
  class Configuration
    attr_accessor :app_name, :app_version, :checks
  end
end
