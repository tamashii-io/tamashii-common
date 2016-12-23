require 'codeme/packet'

module Codeme
  module Resolver
    module_function

    def config(&block)
      class_eval(&block)
    end

    def handle(type_code, handler_class, options = {})
      raise NotImplementedError.new("Handler should implement resolve method") unless handler_class.method_defined?(:resolve)
      @handlers ||= {}
      @handlers[type_code] = [handler_class, options]
    end

    def resolve(pkt, env = {})
      @handlers ||= {}
      handler, options = @handlers[pkt.type] || [nil, nil]
      handler.new(pkt.type, options.merge(env)).resolve(pkt.body) if handler
    end

    def handle?(type_code)
      @handlers.has_key? type_code
    end
  end
end

