require 'spec_helper'
require "rack/healthcheck/type"

describe Rack::Healthcheck::Checks::Base do
  let(:name) { "name" }
  let(:type) { Rack::Healthcheck::Type::DATABASE }

  subject(:base_check) { described_class.new(name, type) }

  describe ".new" do
    describe "when an invalid type is informed" do
      let(:type) { "type" }

      it "raises Rack::Healthcheck::Checks::Base::InvalidType exception" do
        expect{ base_check }.to raise_error(Rack::Healthcheck::Checks::Base::InvalidType)
      end
    end
  end

  describe "#to_hash" do
    it "returns only filled attributes" do
      expect(base_check.to_hash.keys).to contain_exactly(:name, :type, :optional)
    end
  end

  describe "#keep_in_pool?" do
    describe "when optional is true" do
      before(:each) do
        base_check.optional = true
      end

      describe "when status is true" do
        it 'returns true' do
          allow(base_check).to receive(:status).and_return(true)

          expect(base_check.keep_in_pool?).to be_truthy
        end
      end

      describe "when status is false" do
        it 'returns true' do
          allow(base_check).to receive(:status).and_return(false)

          expect(base_check.keep_in_pool?).to be_truthy
        end
      end
    end

    describe "when optional is false" do
      before(:each) do
        base_check.optional = false
      end

      describe "when status is true" do
        it 'returns true' do
          allow(base_check).to receive(:status).and_return(true)

          expect(base_check.keep_in_pool?).to be_truthy
        end
      end

      describe "when status is false" do
        it 'returns false' do
          allow(base_check).to receive(:status).and_return(false)

          expect(base_check.keep_in_pool?).to be_falsy
        end
      end

    end
  end
end
