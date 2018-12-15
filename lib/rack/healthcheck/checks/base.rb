module Rack
  module Healthcheck
    module Checks
      class Base
        class InvalidType < RuntimeError; end

        attr_accessor :name, :optional, :url
        attr_reader :type, :status, :elapsed_time

        def initialize(name, type, optional, url)
          unless Rack::Healthcheck::Type::ALL.include?(type)
            raise InvalidType, "Type must be one of these options #{Rack::Healthcheck::Type::ALL.join(', ')}"
          end

          @name = name
          @optional = optional || false
          @url = url
          @type = type
        end

        def run
          start = Time.now
          check
          @elapsed_time = Time.now - start
        end

        def to_hash
          {
            name: name,
            type: type,
            status: status,
            optional: optional,
            time: elapsed_time,
            url: url
          }.reject { |_key, value| value.nil? }
        end

        def keep_in_pool?
          (!optional && status == true) || optional
        end

        private

        def check; end
      end
    end
  end
end
