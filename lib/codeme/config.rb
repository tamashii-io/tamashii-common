module Codeme
  class Config < Hash
    SHARED_CONFIG = %i(auth_type token log_file log_level token env).freeze

    class << self
      attr_accessor :default_config

      def method_missing(name, *args, &block)
        (@instance ||= Config.new).send(name, *args, &block)
      end

      def register(name, default = nil)
        self.default_config ||= {}
        self.default_config[name.to_sym] = default
      end
    end

    def initialize
      @accept_config = Set.new(SHARED_CONFIG)
      (self.class.default_config || {}).each { |name, value| register(name, value) }
    end

    def method_missing(name, *args, &block)
      return unless accept?(name) || accept?(name[0..-2])
      return register(name[0..-2], args.first) if name[-1..-1] == "="
      return register(name, args.first) if args.size > 0
      return register(name, yield(self)) if block_given?
      self[name]
    end

    def register(key, default = nil)
      @accept_config.add(key.to_sym)
      self[key.to_sym] = default if default
    end

    def accept?(key)
      @accept_config.include?(key.to_sym)
    end
  end
end
