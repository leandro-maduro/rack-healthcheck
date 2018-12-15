module Rack
  module Healthcheck
    # This class is responsible by keep all services that the healthcheck needs to verify
    #
    # app_name [String] This value is used only in complete check result
    # app_version [String] This value is used only in complete check result
    # checks [Array] Array that contains all services that healthcheck needs to verify
    # @example
    # app_name = "Rack Healthcheck"
    # app_version = 1.0
    # checks = [
    #   Rack::Healthcheck::Checks::ActiveRecord.new("database"),
    #   Rack::Healthcheck::Checks::Redis.new("redis", {})
    # ]
    class Configuration
      attr_accessor :app_name, :app_version
      attr_writer :checks

      def checks
        @checks || {}
      end
    end
  end
end
