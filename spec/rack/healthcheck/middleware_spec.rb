require "spec_helper"

describe Rack::Healthcheck::Middleware do
  let(:app) { double }
  let(:env) do
    {
      "PATH_INFO" => path,
      "REQUEST_METHOD" => request_method
    }
  end

  subject(:middleware) { described_class.new(app) }

  describe "#call" do
    let(:path) { "/healthcheck" }
    let(:request_method) { "GET" }

    context "when is not a healthcheck request" do
      let(:path) { "/path" }

      it "sends request to app" do
        allow(Rack::Healthcheck::Action).to receive(:get).and_raise(Rack::Healthcheck::Action::InvalidAction)
        expect(app).to receive(:call).once

        middleware.call(env)
      end
    end

    context "when is an invalid request method" do
      let(:request_method) { "PATH" }

      it "sends request to app" do
        allow(Rack::Healthcheck::Action).to receive(:get).and_raise(Rack::Healthcheck::Actions::Base::InvalidRequestMethod)
        expect(app).to receive(:call).once

        middleware.call(env)
      end
    end

    context "when is a healthcheck request" do
      let(:action) { Rack::Healthcheck::Actions::LoadBalancer.new(path, request_method) }
      it "performs the checks" do
        allow(Rack::Healthcheck::Action).to receive(:get).and_return(action)

        expect(action).to receive(:get).once
        middleware.call(env)
      end
    end
  end
end
