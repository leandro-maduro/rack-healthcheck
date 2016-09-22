require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"

module Rack::Healthcheck::Checks
  class RabbitMq < Base
    attr_reader :config

    # @param name [String]
    # @param config [Hash<Symbol,String>]
    # @param optional [Boolean] Flag used to inform if this service is optional
    # @example
    # name = RabbitMQ
    # config = {
    #   hosts: [localhost]
    #   port: 5672
    #   user: guest
    #   pass: guest
    # }
    # optional = true
    def initialize(name, config, optional = false)
      super(name, optional, config[:hosts])
      @type   = Rack::Healthcheck::Type::MESSAGING
      @config = config
    end

    private

    def check
      connection = Bunny.new(config)
      connection.start
      connection.close
      @status = true
    rescue Exception => e
      @status = false
    end
  end
end
