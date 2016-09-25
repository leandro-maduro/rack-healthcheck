require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"

module Rack::Healthcheck::Checks
  class ActiveRecord < Base
    # @param name [String]
    # @param config [Hash<Symbol, Object>] Hash with optional configs
    # @example
    # name = Database
    # config {
    #   optional: false,
    #   url: "mydatabase.com"
    # }
    def initialize(name, config = {})
      super(name, Rack::Healthcheck::Type::DATABASE, config[:optional], config[:url])
    end

    private

    def check
      ::ActiveRecord::Migrator.current_version
      @status = true
    rescue Exception => e
      @status = false
    end
  end
end
