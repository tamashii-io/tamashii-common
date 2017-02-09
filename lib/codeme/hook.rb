module Codeme
  class Hook
    attr_reader :env

    def initialize(env)
      @env = env
    end

    def call(pkt)
      raise NotImplementedError.new("Hook should implement the #call method")
    end
  end
end
