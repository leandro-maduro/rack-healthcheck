module Rack::Healthcheck::Checks
  class Base
    attr_accessor :name, :optional, :url
    attr_reader :type, :status, :elapsed_time

    def initialize(name, optional = false, url = nil)
      @name = name
      @optional = optional
      @url = url
    end

    def run
      start = Time.now
      check
      @elapsed_time = Time.now - start
    end

    private

    def check
    end
  end
end
