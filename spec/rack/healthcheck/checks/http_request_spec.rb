require 'spec_helper'
require "rack/healthcheck/type"

describe Rack::Healthcheck::Checks::HttpRequest do
  let(:config) do
    {
      url: "http://localhost.com",
      service_type: Rack::Healthcheck::Type::INTERNAL_SERVICE,
      expected_result: "LIVE"
    }
  end
  let(:http_request_check) { Rack::Healthcheck::Checks::HttpRequest.new("name", config) }

  describe ".new" do
    it "sets type as INTERNAL_SERVICE" do
      expect(http_request_check.type).to eq(Rack::Healthcheck::Type::INTERNAL_SERVICE)
    end

    describe "when an invalid type is informed" do
      let(:config) do
        {
          url: "http://localhost.com",
          expected_result: "LIVE"
        }
      end

      it "raises Rack::Healthcheck::Checks::Base::InvalidType exception" do
        expect{http_request_check}.to raise_error(Rack::Healthcheck::Checks::Base::InvalidType)
      end
    end
  end

  describe "#run" do
    let(:response) { double }

    subject(:run_it) { http_request_check.run }

    before(:each) do
      allow_any_instance_of(Net::HTTP).to receive(:get).with(any_args).and_return(response)
    end

    describe "when server is available and returns the expected result" do
      it "sets status to true" do
        allow(response).to receive(:body).and_return("LIVE")
        run_it

        expect(http_request_check.status).to be_truthy
      end
    end

    describe "when server is available and doen't return the expected result" do
      it "sets status to false" do
        allow(response).to receive(:body).and_return("something")
        run_it

        expect(http_request_check.status).to be_falsy
      end
    end

    describe "when server is down" do
      it "sets status to false" do
        allow(response).to receive(:body).and_raise(Exception)
        run_it

        expect(http_request_check.status).to be_falsy
      end
    end

    it "sets elapsed_time" do
      run_it

      expect(http_request_check.elapsed_time).to_not be_nil
    end
  end
end
