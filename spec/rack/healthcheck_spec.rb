require 'spec_helper'

describe Rack::Healthcheck do
  it 'has a version number' do
    expect(Rack::Healthcheck::VERSION).not_to be nil
  end
end
