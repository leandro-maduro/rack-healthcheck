$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "simplecov"
require "pry"
require "timecop"

SimpleCov.start do
  add_filter "/spec"
end

require "rack/healthcheck"
