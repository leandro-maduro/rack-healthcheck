require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"

module Rack::Healthcheck::Checks
  class ActiveRecord < Base
    # @param name [String]
    # @param optional [Boolean] Flag used to inform if this service is optional
    # @param url [String] Used only to display the url service in json response
    # @example
    # name = Database
    # optional = false
    # url = "mydatabase.com"
    def initialize(name, optional = false, url = nil)
      super(name, Rack::Healthcheck::Type::DATABASE, optional, url)
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
