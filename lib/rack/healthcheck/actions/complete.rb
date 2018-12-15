require "json"
require "rack/healthcheck/actions/base"
require "rack/healthcheck/checks/active_record"
require "rack/healthcheck/checks/mongo_db"
require "rack/healthcheck/checks/rabbit_mq"
require "rack/healthcheck/checks/redis"
require "rack/healthcheck/checks/http_request"

module Rack
  module Healthcheck
    module Actions
      class Complete < Base
        def get
          perform
          ["200", { "Content-Type" => "application/json" }, [result.to_json]]
        end

        private

        def result
          results = []
          status  = true
          Rack::Healthcheck.configuration.checks.each do |check|
            status = (status == true && check.keep_in_pool?)
            results << check.to_hash
          end

          {
            name: Rack::Healthcheck.configuration.app_name,
            status: status,
            version: Rack::Healthcheck.configuration.app_version,
            checks: results
          }
        end

        def perform
          threads = Rack::Healthcheck.configuration.checks.map do |check|
            Thread.new { check.run }
          end

          threads.each(&:join)
        end
      end
    end
  end
end
