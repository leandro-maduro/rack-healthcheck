require "rack/healthcheck/checks/base"
require "rack/healthcheck/type"

module Rack::Healthcheck::Checks
  class ActiveRecord < Base
    def initialize(name, optional = false, url = nil)
      super(name, optional, url)
      @type = Rack::Healthcheck::Type::DATABASE
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
