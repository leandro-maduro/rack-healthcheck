require "spec_helper"
require "rack/healthcheck/type"

describe Rack::Healthcheck::Checks::Redis do
  class Redis
    def initialize(config); end

    def info; end
  end

  let(:config) do
    {
      url: "localhost",
      password: 6379
    }
  end
  let(:redis_check) { described_class.new("name", config) }

  describe ".new" do
    it "sets type as CACHE" do
      expect(redis_check.type).to eq(Rack::Healthcheck::Type::CACHE)
    end
  end

  describe "#run" do
    subject(:run_it) { redis_check.run }

    context "when redis server is available" do
      it "sets status to true" do
        run_it

        expect(redis_check.status).to be_truthy
      end
    end

    context "when redis server is down" do
      before do
        allow_any_instance_of(Redis).to receive(:info).and_raise(StandardError)
      end

      it "sets status to false" do
        run_it

        expect(redis_check.status).to be_falsy
      end
    end

    it "sets elapsed_time" do
      run_it

      expect(redis_check.elapsed_time).to_not be_nil
    end
  end
end
