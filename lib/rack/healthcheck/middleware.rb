require "rack/healthcheck/action"

module Rack::Healthcheck
  class Middleware
    def initialize(app, mount_at = nil)
      @app = app
      Rack::Healthcheck::Action.mount_at = mount_at unless mount_at.nil?
    end

    def call(env)
      path = env["PATH_INFO"]
      request_method = env["REQUEST_METHOD"]

      action = Rack::Healthcheck::Action.get(path, request_method)
      action.send(request_method.downcase)
    rescue Rack::Healthcheck::Action::InvalidAction, Rack::Healthcheck::Actions::Base::InvalidRequestMethod
      @app.call(env)
    end
  end
end
