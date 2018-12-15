require "rack/healthcheck/actions/load_balancer"
require "rack/healthcheck/actions/complete"

module Rack
  module Healthcheck
    class Action
      class InvalidAction < RuntimeError; end

      @mount_at = "healthcheck"

      class << self
        attr_accessor :mount_at

        def get(path, request_method)
          raise InvalidAction, "Unknown action" unless available_actions.key?(path)

          available_actions[path].send(:new, path, request_method)
        end

        def available_actions
          route = @mount_at.gsub(%r{^/}, "")
          {
            "/#{route}" => Rack::Healthcheck::Actions::LoadBalancer,
            "/#{route}/complete" => Rack::Healthcheck::Actions::Complete
          }
        end
      end

      private_class_method :new
    end
  end
end
