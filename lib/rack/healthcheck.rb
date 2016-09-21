require "rack/healthcheck/version"
require "rack/healthcheck/middleware"
require "rack/healthcheck/configuration"

module Rack
  module Healthcheck
    class << self
      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end
    end
  end
end
