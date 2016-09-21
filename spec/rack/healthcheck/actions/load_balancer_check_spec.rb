require "spec_helper"

describe Rack::Healthcheck::Actions::LoadBalancerCheck do
  describe ".new" do
    describe "with invalid request method" do
      subject { described_class.new("/path", "PATH") }

      it "raises InvalidRequestMethod exception" do
        expect{subject}.to raise_error(Rack::Healthcheck::Actions::BaseCheck::InvalidRequestMethod, "Method not allowed")
      end
    end
  end

  describe "#get" do
    describe "when status is LIVE" do
      subject(:check) { described_class.new("/healthcheck", "get") }

      it 'returns LIVE' do
        expect(check.get).to include(["LIVE"])
      end
    end

    describe "when status is DEAD" do
      subject(:check) { described_class.new("/healthcheck", "get") }

      before do
        Rack::Healthcheck::Actions::LoadBalancerCheck.status = Rack::Healthcheck::Actions::LoadBalancerCheck::DEAD
      end

      it 'returns DEAD' do
        expect(check.get).to include(["DEAD"])
      end
    end

  end

  describe "#post" do
    subject(:check) { described_class.new("/healthcheck", "post") }

    before(:each) do
      Rack::Healthcheck::Actions::LoadBalancerCheck.status = Rack::Healthcheck::Actions::LoadBalancerCheck::DEAD
    end

    it 'returns LIVE' do
      expect(check.post).to include(["LIVE"])
    end

    it 'changes variable value to LIVE' do
      check.post

      expect(Rack::Healthcheck::Actions::LoadBalancerCheck.status).to eq(Rack::Healthcheck::Actions::LoadBalancerCheck::LIVE)
    end
  end

  describe "#delete" do
    subject(:check) { described_class.new("/healthcheck", "delete") }

    before(:each) do
      Rack::Healthcheck::Actions::LoadBalancerCheck.status = Rack::Healthcheck::Actions::LoadBalancerCheck::LIVE
    end

    it 'returns DEAD' do
      expect(check.delete).to include(["DEAD"])
    end

    it 'changes variable value to DEAD' do
      check.delete
      
      expect(Rack::Healthcheck::Actions::LoadBalancerCheck.status).to eq(Rack::Healthcheck::Actions::LoadBalancerCheck::DEAD)
    end
  end
end
