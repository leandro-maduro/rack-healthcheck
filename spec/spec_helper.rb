$LOAD_PATH.unshift File.expand_path("../lib", __dir__)
require "coveralls"
require "simplecov"
require "pry"
require "timecop"

Coveralls.wear!

SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::HTMLFormatter,
                                                                 Coveralls::SimpleCov::Formatter
                                                               ])

SimpleCov.start do
  add_filter "/spec"
end

require "rack/healthcheck"
