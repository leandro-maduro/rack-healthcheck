require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"

module Rack::Healthcheck::Checks
  class RabbitMQ < Base
    attr_reader :config

    # @param name [String]
    # @param config [Hash<Symbol,Object>] Hash with configs
    # @example
    # name = RabbitMQ
    # config = {
    #   hosts: [localhost],
    #   port: 5672,
    #   user: guest,
    #   pass: guest,
    #   optional: true
    # }
    def initialize(name, config)
      super(name, Rack::Healthcheck::Type::MESSAGING, config[:optional], config[:hosts])
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
