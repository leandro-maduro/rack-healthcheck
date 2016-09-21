require "spec_helper"
#require "rack/healthcheck/actions/base_"

describe Rack::Healthcheck::Actions::CompleteCheck do
  describe ".new" do
    describe "with invalid request method" do
      subject { described_class.new("/path", "POST") }

      it "raises InvalidRequestMethod exception" do
        expect{subject}.to raise_error(Rack::Healthcheck::Actions::BaseCheck::InvalidRequestMethod, "Method not allowed")
      end
    end
  end
end
