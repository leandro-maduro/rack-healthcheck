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
        }
      ]
    }
  end

  subject(:action) { described_class.new(path, request_method) }

  describe ".new" do
    describe "with invalid request method" do
      let(:request_method) { "POST" }

      it "raises InvalidRequestMethod exception" do
        expect{ action }.to raise_error(Rack::Healthcheck::Actions::Base::InvalidRequestMethod, "Method not allowed")
      end
    end
  end

  describe "#get" do
    describe "when services are informed" do
      before(:each) do
        Timecop.freeze(Time.now)

        Rack::Healthcheck.configure do |config|
          config.app_name     = "test"
          config.app_version  = 1.0
          config.checks       = [database_check, redis_check]
        end
      end

      after do
        Timecop.return
      end

      it "performs all checks" do
        action.get

        expect(database_check.elapsed_time).to_not be_nil
        expect(redis_check.elapsed_time).to_not be_nil
      end

      it "returns json with all results" do
        expect(action.get.last).to eq([response.to_json])
      end
    end

    describe "when no service is informed" do
      before(:each) do
        Rack::Healthcheck.configure do |config|
          config.app_name     = "test"
          config.app_version  = 1.0
          config.checks       = nil
        end
      end

      it "performs without errors" do
        expect{ action.get }.to_not raise_error
      end
    end
  end
end
