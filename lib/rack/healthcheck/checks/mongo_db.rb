require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"

module Rack::Healthcheck::Checks
  class MongoDb < Base
    def initialize(name, optional = false, url = nil)
      super(name, optional, url)
      @type = Rack::Healthcheck::Type::DATABASE
    end

    private

    def check
      Mongoid::Sessions.with_name(:default).command(dbStats: 1)["db"]
      @status = true
    rescue Exception => e
      @status = false
    end
  end
end
