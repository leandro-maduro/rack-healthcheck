require "spec_helper"

describe Rack::Healthcheck::Actions::Complete do
  let(:path) { "/healthcheck" }
  let(:request_method) { "GET" }
  let(:database_check) { Rack::Healthcheck::Checks::ActiveRecord.new("database") }
  let(:redis_check) { Rack::Healthcheck::Checks::Redis.new("redis", {}) }
  let(:response) do
    {
      name: "test",
      status: false,
      version: 1.0,
      checks: [{
        name: "database",
        type: "DATABASE",
        status: false,
        optional: false,
        time: 0.0
      }, {
        name: "redis",
        type: "CACHE",
        status: false,
        optional: false,
        time: 0.0
      }]
    }
  end

  subject(:action) { described_class.new(path, request_method) }

  describe ".new" do
    context "with invalid request method" do
      let(:request_method) { "POST" }

      it "raises InvalidRequestMethod exception" do
        expect { action }.to raise_error(Rack::Healthcheck::Actions::Base::InvalidRequestMethod, "Method not allowed")
      end
    end
  end

  describe "#get" do
    context "when services are informed" do
      before(:each) do
        Timecop.freeze(Time.now)

        allow_any_instance_of(Rack::Healthcheck::Checks::ActiveRecord).to receive(:status) { false }
        allow_any_instance_of(Rack::Healthcheck::Checks::Redis).to receive(:status) { false }

        Rack::Healthcheck.configure do |config|
          config.app_name     = "test"
          config.app_version  = 1.0
          config.checks       = [database_check, redis_check]
        end
      end

      after do
        Timecop.return
      end

      it "returns json with all results" do
        expect(JSON.parse(action.get.last[0], symbolize_names: true)).to eq(response)
      end
    end

    context "when no service is informed" do
      before(:each) do
        Rack::Healthcheck.configure do |config|
          config.app_name     = "test"
          config.app_version  = 1.0
          config.checks       = nil
        end
      end

      it "performs without errors" do
        expect { action.get }.to_not raise_error
      end
    end
  end
end
