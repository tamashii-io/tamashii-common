module  Codeme
  class Handler
    attr_reader :type_code, :env
    def initialize(type_code, env = {})
      @type_code = type_code
      @env = env
    end

    def resolve(action_code, data = nil)
      raise NotImplementError.new("The resolve method should be implemented.")
    end
  end
end

