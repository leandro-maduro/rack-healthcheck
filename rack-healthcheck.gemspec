lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rack/healthcheck/version"

Gem::Specification.new do |spec|
  spec.name          = "rack-healthcheck"
  spec.version       = Rack::Healthcheck::VERSION
  spec.authors       = ["Leandro Maduro"]
  spec.email         = ["leandromaduro1@gmail.com"]

  spec.summary       = "A healthcheck interface for Sinatra and Rails framework"
  spec.description   = "A healthcheck interface for Sinatra and Rails framework"
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
end
