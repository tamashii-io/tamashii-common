module Codeme
  class Packet
    attr_reader :type
    attr_reader :body
    
    # 1 byte: type
    # 2 bytes: size of body
    # variable-length body, in string
    def self.dump(obj)
      raise "Only Packet can be dump" unless obj.is_a?(self)
      header = [obj.type, obj.body.size].pack("Cn")
      header + obj.body
    end

    def self.load(orig_str)
      str = orig_str.clone
      header = str.slice!(0..2).unpack("Cn")
      # str is the body now
      new(header[0], str)
    end
    
    def initialize(type, body)
      @type = type
      @body = body
    end

    def dump
      self.class.dump(self)
    end
  end
end
