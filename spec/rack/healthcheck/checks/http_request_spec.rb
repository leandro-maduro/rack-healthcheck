require "spec_helper"
require "rack/healthcheck/type"

describe Rack::Healthcheck::Checks::HTTPRequest do
  let(:config) do
    {
      url: "http://localhost.com",
      service_type: Rack::Healthcheck::Type::INTERNAL_SERVICE,
      expected_result: "LIVE"
    }
  end
  let(:http_request_check) { described_class.new("name", config) }

  describe ".new" do
    it "sets type as INTERNAL_SERVICE" do
      expect(http_request_check.type).to eq(Rack::Healthcheck::Type::INTERNAL_SERVICE)
    end
  end

  describe "#run" do
    subject(:run_it) { http_request_check.run }

    let(:response) { double(:response, body: body) }
    let(:body) { "LIVE" }

    before(:each) do
      allow_any_instance_of(Net::HTTP).to receive(:get).with(any_args) { response }
    end

    context "when server is available and returns the expected result" do
      it "sets status to true" do
        run_it

        expect(http_request_check.status).to be_truthy
      end
    end

    context "when server is available and doen't return the expected result" do
      let(:body) { "something" }

      it "sets status to false" do
        run_it

        expect(http_request_check.status).to be_falsy
      end
    end

    context "when server is down" do
      before do
        allow(response).to receive(:body).and_raise(StandardError)
      end

      it "sets status to false" do
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
