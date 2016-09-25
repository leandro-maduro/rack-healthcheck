require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"
require "uri"
require "net/http"

module Rack::Healthcheck::Checks
  class HTTPRequest < Base
    class InvalidURL < Exception; end;

    attr_reader :config

    # @param name [String]
    # @param config [Hash<Symbol, Object>] Hash with configs
    # @example
    # name = Ceph or Another system
    # config = {
    #   url: localhost,
    #   headers: {"Host" => "something"},
    #   service_type: "INTERNAL_SERVICE",
    #   expected_result: "LIVE",
    #   optional: true
    # }
    # @see Rack::Healthcheck::Type
    def initialize(name, config)
      raise InvalidURL.new("Expected :url to be a http or https endpoint") if config[:url].match(/^(http:\/\/|https:\/\/)/).nil?

      super(name, config[:service_type], config[:optional], config[:url])
      @config = config
    end

    private

    def check
      uri = URI(url)
      http = Net::HTTP.new(uri.host)
      response = http.get(uri.path, config[:headers])
      @status = response.body.gsub(/\n/, '') == config[:expected_result]
    rescue Exception => e
      @status = false
    end
  end
end
