require "spec_helper"

describe Rack::Healthcheck::Actions::LoadBalancer do
  describe ".new" do
    describe "with invalid request method" do
      subject(:action) { described_class.new("/path", "PATH") }

      it "raises InvalidRequestMethod exception" do
        expect{ action }.to raise_error(Rack::Healthcheck::Actions::Base::InvalidRequestMethod, "Method not allowed")
      end
    end
  end

  describe "#get" do
    describe "when status is LIVE" do
      subject(:action) { described_class.new("/healthcheck", "get") }

      it 'returns LIVE' do
        expect(action.get).to include(["LIVE"])
      end
    end

    describe "when status is DEAD" do
      subject(:action) { described_class.new("/healthcheck", "get") }

      before do
        Rack::Healthcheck::Actions::LoadBalancer.status = Rack::Healthcheck::Actions::LoadBalancer::DEAD
      end

      it 'returns DEAD' do
        expect(action.get).to include(["DEAD"])
      end
    end
  end

  describe "#post" do
    subject(:action) { described_class.new("/healthcheck", "post") }

    before(:each) do
      Rack::Healthcheck::Actions::LoadBalancer.status = Rack::Healthcheck::Actions::LoadBalancer::DEAD
    end

    it 'returns LIVE' do
      expect(action.post).to include(["LIVE"])
    end

    it 'changes variable value to LIVE' do
      action.post

      expect(Rack::Healthcheck::Actions::LoadBalancer.status).to eq(Rack::Healthcheck::Actions::LoadBalancer::LIVE)
    end
  end

  describe "#delete" do
    subject(:action) { described_class.new("/healthcheck", "delete") }

    before(:each) do
      Rack::Healthcheck::Actions::LoadBalancer.status = Rack::Healthcheck::Actions::LoadBalancer::LIVE
    end

    it 'returns DEAD' do
      expect(action.delete).to include(["DEAD"])
    end

    it 'changes variable value to DEAD' do
      action.delete

      expect(Rack::Healthcheck::Actions::LoadBalancer.status).to eq(Rack::Healthcheck::Actions::LoadBalancer::DEAD)
    end
  end
end
