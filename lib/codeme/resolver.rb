require 'codeme/packet'

module  Codeme
  class Handler
    def initialize(env = {})
      @env = env          
    end

    def resolve(action_code, data = nil)
      puts "Not yet implemented"
    end
  end
end

module Codeme

  TYPE_CODE_SYSTEM = 0 << 3
  TYPE_CODE_AUTH = 1 << 3
  TYPE_CODE_RFID = 3 << 3
  TYPE_CODE_BUZZER = 4 << 3


  ACTION_CODE_SYSTEM_POWEROFF = 0
  ACTION_CODE_SYSTEM_REBOOT = 0

  ACTION_CODE_AUTH_TOKEN = 0
  ACTION_CODE_AUTH_RESULT = 7

  ACTION_CODE_RFID_NUMBER = 0
  ACTION_CODE_RFID_DATA = 1
  ACTION_CODE_RFID_RESULT_JSON = 6
  ACTION_CODE_RFID_RESULT_STRING = 7

  ACTION_CODE_BUZZER_SOUND = 0

  module Resolver
    module_function

    def config(&block)
      @handlers = {}
      class_eval(&block)
    end

    def handler(type_code, handler_class, env = {})
      @handlers[type_code] = {class: handler_class, env: env}
    end

    def resolve(pkt)
      data = @handlers[pkt.type_code] || {class: Handler, env: {}}
      data[:class].new(data[:env]).resolve(pkt.action_code, pkt.body)
    end

    def handle?(type_code)
      @handlers.has_key? type_code
    end
  end
end

