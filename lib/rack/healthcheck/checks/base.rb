module Rack::Healthcheck::Checks
  class Base
    class InvalidType < Exception; end;

    attr_accessor :name, :optional, :url
    attr_reader :type, :status, :elapsed_time

    def initialize(name, type, optional, url)
      raise InvalidType.new("Type must be one of these options #{Rack::Healthcheck::Type::ALL.join(", ")}") unless Rack::Healthcheck::Type::ALL.include?(type)

      @name = name
      @optional = optional || false
      @url = url
      @type = type
    end

    def run
      start = Time.now
      check
      @elapsed_time = Time.now - start
    end

    def to_hash
      {
        name: name,
        type: type,
        status: status,
        optional: optional,
        time: elapsed_time,
        url: url
      }.reject{ |key, value| value.nil? }
    end

    def keep_in_pool?
      (!optional && status == true) || optional
    end

    private

    def check
    end
  end
end
