require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"

module Rack
  module Healthcheck
    module Checks
      class MongoDB < Base
        # @param name [String]
        # @param config [Hash<Symbol, Object>] Hash with optional configs
        # @example
        # name = Database
        # config {
        #   optional: false,
        #   url: "mymongodb.com"
        # }
        def initialize(name, config = {})
          super(name, Rack::Healthcheck::Type::DATABASE, config[:optional], config[:url])
        end

        private

        def check
          Mongoid::Sessions.with_name(:default).command(dbStats: 1)["db"]
          @status = true
        rescue StandardError => _
          @status = false
        end
      end
    end
  end
end
