require "spec_helper"
require "rack/healthcheck/type"

module ActiveRecord
  class Migrator
  end
end

describe Rack::Healthcheck::Checks::ActiveRecord do
  let(:active_record_check) { described_class.new("name") }

  describe ".new" do
    it "sets type as DATABASE" do
      expect(active_record_check.type).to eq(Rack::Healthcheck::Type::DATABASE)
    end
  end

  describe "#run" do
    subject(:run_it) { active_record_check.run }

    context "when database is up" do
      before do
        allow(ActiveRecord::Migrator).to receive(:current_version) { "1" }
      end

      it "sets status to true" do
        run_it

        expect(active_record_check.status).to be_truthy
      end
    end

    context "when database is down" do
      before do
        allow(ActiveRecord::Migrator).to receive(:current_version).and_raise(StandardError)
      end

      it "sets status to false" do
        run_it

        expect(active_record_check.status).to be_falsy
      end
    end

    it "sets elapsed_time" do
      run_it

      expect(active_record_check.elapsed_time).to_not be_nil
    end
  end
end
