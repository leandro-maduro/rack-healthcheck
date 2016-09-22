require "spec_helper"

describe Rack::Healthcheck::Actions::Complete do
  describe ".new" do
    describe "with invalid request method" do
      subject { described_class.new("/path", "POST") }

      it "raises InvalidRequestMethod exception" do
        expect{subject}.to raise_error(Rack::Healthcheck::Actions::Base::InvalidRequestMethod, "Method not allowed")
      end
    end
  end
end
