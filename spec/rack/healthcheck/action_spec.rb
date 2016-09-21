require 'spec_helper'

describe Rack::Healthcheck::Action do
  describe ".get" do
    let(:request_method) { "GET" }

    context "using default route" do
      let(:load_balancer_path) { "/healthcheck" }
      let(:complete_path) { "/healthcheck/complete" }

      describe "with valid path_info" do
        it "returns a new instance of LoadBalancerCheck" do
          expect(described_class.get(load_balancer_path, request_method)).to be_a(Rack::Healthcheck::Actions::LoadBalancerCheck)
        end

        it "returns a new instance of CompleteCheck" do
          expect(described_class.get(complete_path, request_method)).to be_a(Rack::Healthcheck::Actions::CompleteCheck)
        end
      end

      describe "with invalid path_info" do
        it "raises Rack::Healthcheck::Action::InvalidAction exception" do
          expect{ described_class.get("bla", request_method) }.to raise_error(Rack::Healthcheck::Action::InvalidAction, "Unknown action")
        end
      end
    end

    context "using another route" do
      let(:new_path) { "/path" }

      before(:each) do
        Rack::Healthcheck::Action.mount_at = new_path
      end

      it "returns a new instance using the new path" do
        expect(described_class.get(new_path, request_method).path).to eq(new_path)
      end
    end
  end
end
