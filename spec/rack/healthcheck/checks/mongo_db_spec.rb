require 'spec_helper'
require "rack/healthcheck/type"

module Mongoid
  class Sessions
  end
end

describe Rack::Healthcheck::Checks::MongoDb do
  let(:mongo_check) { Rack::Healthcheck::Checks::MongoDb.new("name") }

  describe ".new" do
    it "sets type as DATABASE" do
      expect(mongo_check.type).to eq(Rack::Healthcheck::Type::DATABASE)
    end
  end

  describe "#run" do
    subject(:run_it) { mongo_check.run }

    describe "when database is up" do
      let(:connection) { double }
      
      it "returns true" do
        allow(connection).to receive(:command).and_return({"db" => "test"})
        allow(Mongoid::Sessions).to receive(:with_name).with(any_args).and_return(connection)
        run_it

        expect(mongo_check.status).to be_truthy
      end
    end

    describe "when database is down" do
      it "returns false" do
        allow(Mongoid::Sessions).to receive(:with_name).and_raise(Exception)
        run_it

        expect(mongo_check.status).to be_falsy
      end
    end

    it "sets elapsed_time" do
      run_it

      expect(mongo_check.elapsed_time).to_not be_nil
    end
  end
end
