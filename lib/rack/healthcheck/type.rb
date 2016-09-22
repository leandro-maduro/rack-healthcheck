module Rack::Healthcheck
  class Type
    CACHE             = "CACHE".freeze
    EXTERNAL_SERVICE  = "EXTERNAL_SERVICE".freeze
    INTERNAL_SERVICE  = "INTERNAL_SERVICE".freeze
    STORAGE           = "STORAGE".freeze
    MESSAGING         = "MESSAGING".freeze
    DATABASE          = "DATABASE".freeze
    FILE              = "FILE".freeze
  end
end
