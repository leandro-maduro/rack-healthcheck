require "rack/healthcheck/actions/base"

module Rack
  module Healthcheck
    module Actions
      class LoadBalancer < Base
        LIVE = "LIVE".freeze
        DEAD = "DEAD".freeze
        VALID_REQUEST_METHODS = %i[get post delete].freeze

        @status = LIVE
        class << self
          attr_accessor :status
        end

        # Returns the current status to load balancer
        # When status is LIVE the load balancer keeps the machine in pool
        # When status is DEAD the load balancer removes the machine from pool
        def get
          response
        end

        # Change current status to LIVE
        # This method is used to add the machine in pool
        def post
          self.class.status = LIVE
          response
        end

        # Change current status to DEAD
        # This method is used to remove the machine from pool
        def delete
          self.class.status = DEAD
          response
        end

        private

        def response
          ["200", { "Content-Type" => "text/plain" }, [self.class.status]]
        end
      end
    end
  end
end
