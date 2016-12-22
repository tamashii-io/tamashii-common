module Codeme
  class Config < Hash
    class << self
      def method_missing(name, *args, &block)
        (@instance ||= Config.new).send(name, *args, &block)
      end
    end

    SHARED_CONFIG = %i(auth_type token log_file log_level token env)
    ACCEPT_CONFIG = Set.new(SHARED_CONFIG)

    def method_missing(name, *args, &block)
      return unless accept?(name) || accept?(name[0..-2])
      return register(name[0..-2], args.first) if name[-1..-1] == "="
      return register(name, args.first) if args.size > 0
      return register(name, yield(self)) if block_given?
      self[name]
    end

    def register(key, default = nil)
      ACCEPT_CONFIG.add(key.to_sym)
      self[key.to_sym] = default if default
    end

    def accept?(key)
      ACCEPT_CONFIG.include?(key.to_sym)
    end
  end
end
