require "rack/healthcheck/actions/load_balancer_check"
require "rack/healthcheck/actions/complete_check"

module Rack
  module Healthcheck
    class Action
      class InvalidAction < Exception; end;

      @mount_at = "healthcheck"

      class << self
        attr_accessor :mount_at

        def get(path, request_method)
          raise InvalidAction.new("Unknown action") unless available_actions.has_key?(path)

          available_actions[path].send(:new, path, request_method)
        end

        def available_actions
          route = @mount_at.gsub(/^\//, "")
          {
            "/#{route}"           => Rack::Healthcheck::Actions::LoadBalancerCheck,
            "/#{route}/complete"  => Rack::Healthcheck::Actions::CompleteCheck,
          }
        end
      end

      private_class_method :new
    end
  end
end
