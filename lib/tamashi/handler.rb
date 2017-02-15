module  Tamashi
  class Handler
    attr_reader :type, :env
    def initialize(type, env = {})
      @type = type
      @env = env
    end

    def resolve(data = nil)
      raise NotImplementedError.new("The resolve method should be implemented.")
    end
  end
end

