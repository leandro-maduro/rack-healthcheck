require 'spec_helper'
require "rack/healthcheck/type"

describe Rack::Healthcheck::Checks::RabbitMq do
  let(:config) do
    {
      hosts:  ["localhost"],
      port:   5672,
      user:   "guest",
      pass:   "guest"
    }
  end
  let(:rabbit_check) { Rack::Healthcheck::Checks::RabbitMq.new("name", config) }

  before(:each) do
    bunny = Class.new
    bunny.class_eval { def initialize(url); end; def start; end; def close; end}
    stub_const("Bunny", bunny)
  end

  describe ".new" do
    it "sets type as MESSAGING" do
      expect(rabbit_check.type).to eq(Rack::Healthcheck::Type::MESSAGING)
    end
  end

  describe "#run" do
    subject(:run_it) { rabbit_check.run }

    describe "when rabbit server is available" do
      it "sets status to true" do
        run_it

        expect(rabbit_check.status).to be_truthy
      end
    end

    describe "when rabbit server is down" do
      it "sets status to false" do
        allow_any_instance_of(Bunny).to receive(:start).and_raise(Exception)
        run_it

        expect(rabbit_check.status).to be_falsy
      end
    end

    it "sets elapsed_time" do
      run_it

      expect(rabbit_check.elapsed_time).to_not be_nil
    end
  end
end
