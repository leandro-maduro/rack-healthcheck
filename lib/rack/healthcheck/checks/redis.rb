require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"

module Rack::Healthcheck::Checks
  class Redis < Base
    attr_reader :config

    # @param name [String]
    # @param config [Hash<Symbol,String>] Hash with configs
    # @param optional [Boolean] Flag used to inform if this service is optional
    # @example
    # name = Redis
    # config = {
    #   url: "redis://localhost:6379",
    #   password: "pass",
    #   optional: true
    # }
    def initialize(name, config)
      super(name, Rack::Healthcheck::Type::CACHE, config[:optional], config[:url])
      @config = config
    end

    private

    def check
      redis = ::Redis.new(config)
      redis.info
      @status = true
    rescue Exception => e
      @status = false
    end
  end
end
