module Codeme
  class Environment < Hash

    RUNTIME_ENV = %w(test development production)

    def initialize(env = nil, **options)
      self.merge(options)
      self[:env] = env.to_s unless env.nil?
    end

    def method_missing(name, *args, &block)
      return is_env(name[0..-2]) if RUNTIME_ENV.include?(name[0..-2])
      super
    end

    def ==(other)
      self.to_s == other.to_s
    end

    def is_env(env)
      self.to_s == env.to_s
    end

    def to_s
      (self[:env] || ENV['RACK_ENV'] || "development").to_s
    end
  end
end
