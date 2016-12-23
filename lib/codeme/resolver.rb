require 'codeme/packet'

module Codeme
  module Resolver
    module_function

    def config(&block)
      class_eval(&block)
    end

    def handle(type_code, handler_class, options = {})
      raise NotImplementError.new("Handler should implement resolve method") if handler_class.method_defined?(:resolve)
      @handlers ||= {}
      @handlers[type_code] = [handler_class, options]
    end

    def resolve(pkt, env = {})
      @handlers ||= {}
      handler, options = @handlers[pkt.type_code] || [nil, nil]
      handler.new(pkt.type_code, options.merge(env)).resolve(pkt.action_code, pkt.body)
    end

    def handle?(type_code)
      @handlers.has_key? type_code
    end
  end
end

