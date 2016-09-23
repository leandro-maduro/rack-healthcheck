require 'spec_helper'

describe Rack::Healthcheck do
  it 'has a version number' do
    expect(Rack::Healthcheck::VERSION).not_to be nil
  end

  describe ".configure" do
    subject(:configure) do
      Rack::Healthcheck.configure do |config|
        config.app_name     = "test"
        config.app_version  = 1.0
        config.checks       = [
          Rack::Healthcheck::Checks::ActiveRecord.new("database")
        ]
      end
    end

    it "sets app_name" do
      configure

      expect(Rack::Healthcheck.configuration.app_name).to eq("test")
    end

    it "sets app_version" do
      configure

      expect(Rack::Healthcheck.configuration.app_version).to eq(1.0)
    end

    it "sets checks" do
      configure

      expect(Rack::Healthcheck.configuration.checks.size).to eq(1)
    end
  end
end
