require 'codeme/packet'

module Codeme
  class Resolver

    class << self
      def method_missing(name, *args, &block)
        self.instance.send(name, *args, &block)
      end
      
      def instance
        @instance ||= self.new
      end
    end


    def config(&block)
      instance_eval(&block)
    end

    def default_handler(handler_class = nil, env = nil)
      return @default_handler || [nil, nil] if handler_class.nil?
      @default_handler = [handler_class, env]
    end

    def handle(type, handler_class, options = {})
      raise NotImplementedError.new("Handler should implement resolve method") unless handler_class.method_defined?(:resolve)
      @handlers ||= {}
      @handlers[type] = [handler_class, options]
    end

    def resolve(pkt, env = {})
      @handlers ||= {}
      handler, options = @handlers[pkt.type] || @default_handler
      handler.new(pkt.type, options.merge(env)).resolve(pkt.body) if handler
    end

    def handle?(type)
      (@handlers ||= {}).has_key? type
    end
  end
end

