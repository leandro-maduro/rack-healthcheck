[![Gem Version](https://badge.fury.io/rb/rack-healthcheck.svg)](https://badge.fury.io/rb/rack-healthcheck)
[![Build Status](https://travis-ci.org/downgba/rack-healthcheck.svg?branch=master)](https://travis-ci.org/downgba/rack-healthcheck)
[![Test Coverage](https://api.codeclimate.com/v1/badges/b1e9fec230d987b04f29/test_coverage)](https://codeclimate.com/github/downgba/rack-healthcheck/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/b1e9fec230d987b04f29/maintainability)](https://codeclimate.com/github/downgba/rack-healthcheck/maintainability)

# Rack::Healthcheck

Is a middleware that verifies if your app and all resources that it needs are available.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rack-healthcheck'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-healthcheck

## Usage

###### Rails
```ruby
# config/application.rb
config.middleware.use Rack::Healthcheck::Middleware
```

###### Sinatra
```ruby
# config.ru
use Rack::Healthcheck::Middleware
```

### Setting up

Create an initializer file, where you'll setup all services that you use.

```ruby
Rack::Healthcheck.configure do |config|
  config.app_name = "Your Application"
  config.app_version = 1.0
  config.checks = [
    Rack::Healthcheck::Checks::ActiveRecord.new("Database"),
    Rack::Healthcheck::Checks::RabbitMQ.new(name, config = {
      hosts: [localhost],
      port: 5672,
      user: guest,
      pass: guest
    }),
    Rack::Healthcheck::Checks::Redis.new(name, config = {
      url: "redis://localhost:6379",
      password: "pass"
    })
    Rack::Healthcheck::Checks::HTTPRequest.new(name, config = {
      url: localhost,
      headers: {"Host" => "something"},
      service_type: "INTERNAL_SERVICE",
      expected_result: "LIVE"
    })
  ]
end
```

##### Available checks

* Rack::Healthcheck::Checks::ActiveRecord.new(name, config = {})
* Rack::Healthcheck::Checks::MongoDB.new(name, config = {})
* Rack::Healthcheck::Checks::RabbitMQ.new(name, config = {})
* Rack::Healthcheck::Checks::Redis.new(name, config = {})
* Rack::Healthcheck::Checks::HTTPRequest.new(name, config = {})

You can inform if one of your checks is optional, so this check will be disregarded in final result.
To do that you just need to pass a hash with `:optional` key.

```ruby
Rack::Healthcheck::Checks::ActiveRecord.new("Test", {optional: true})
```

If you want to display the service url in final result, you need to pass it in hash config too.

```ruby
Rack::Healthcheck::Checks::ActiveRecord.new("Test", {optional: true, url: "http://myservice.com/healthcheck"})
```
### Routes

By default this gem creates two routes `/healthcheck` and `/healthcheck/complete`.

The `/healthcheck` route doesn't verify the services used by application. This is the fastest way to tell to load balancer if it should or not keep the machine in the pool.
These are the available HTTP methods for this route:

* GET -> Returns the current status (LIVE|DEAD)
* POST -> Changes the current status to LIVE
* DELETE -> Changes the current status to DEAD

The `/healthcheck/complete` performs all configured checks and returns a JSON with a lot of information (elapsed time, status for each service, global status considering only required services).
Example:
```json
{
  "name": "My application",
  "status": true,
  "version": 1.0,
  "checks": [
    {
      "name": "Oracle database",
      "type": "DATABASE",
      "status": true,
      "optional": false,
      "time": 0.036443
    }
  ]
}
```

##### Changing default routes

If you want to change the default route, you just need to pass the new route to the middleware

```ruby
# For rails
# config/application.rb
config.middleware.use Rack::Healthcheck::Middleware, "/myroute"
# or
# For sinatra
# config.ru
use Rack::Healthcheck::Middleware, "/myroute"
```

## Contributing

1. Fork it ( https://github.com/downgba/rack-healthcheck/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
