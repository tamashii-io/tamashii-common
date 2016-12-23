module  Codeme
  class Handler
    attr_reader :type_code, :env
    def initialize(type, env = {})
      @type = type
      @env = env
    end

    def resolve(action_code, data = nil)
      raise NotImplementError.new("The resolve method should be implemented.")
    end
  end
end

