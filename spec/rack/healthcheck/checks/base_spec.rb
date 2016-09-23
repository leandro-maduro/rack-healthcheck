require 'spec_helper'
require "rack/healthcheck/type"

describe Rack::Healthcheck::Checks::Base do
  describe ".new" do
    describe "when an invalid type is informed" do
      let(:base_check) { described_class.new("name", "type") }

      it "raises Rack::Healthcheck::Checks::Base::InvalidType exception" do
        expect{ base_check }.to raise_error(Rack::Healthcheck::Checks::Base::InvalidType)
      end
    end
  end
end
