module Tamashii
  class Packet


    DEVICE_TYPE_AGENT = 0
    DEVICE_TYPE_CHECKIN = 1

    STRING_TRUE = "0".freeze
    STRING_FALSE = "1".freeze

    attr_reader :type
    attr_reader :tag
    attr_reader :body
    

    # 1 byte: type
    # 2 bytes: tag
    # 2 bytes: size of body
    # variable-length body, in string
    def self.dump(obj)
      raise TypeError.new("Only Packet can be dump") unless obj.is_a?(self)
      raise TypeError.new("Body must be a string") unless obj.body.is_a?(String)
      header = [obj.type, *split_integer(obj.tag), *split_integer(obj.body.bytesize)]
      header + obj.body.unpack("C*")
    end

    def self.split_integer(n, byte_num = 2)
      res = []
      byte_num.times do 
        res.unshift(n & 0xFF)
        n >>= 8
      end
      res
    end

    def self.combine_integer(bytes)
      n = 0
      bytes.each do |byte|
        n = n << 8 | byte
      end
      n
    end

    def self.load(byte_array)
      header_bytes = byte_array[0..4] 
      body_bytes = byte_array[5..-1] || ""
      packed_data = if body_bytes.is_a? String
                      body_bytes
                    else
                      body_bytes.pack("C*")
                    end
      new(header_bytes[0], combine_integer(header_bytes[1..2]), packed_data)
    rescue
      nil
    end
    
    def initialize(type, tag = 0, body = '')
      @type = type
      @tag =  tag
      @body = body
      body_conversion
    end

    def body_conversion
      if @body.is_a? TrueClass
        @body = STRING_TRUE.clone
      elsif @body.is_a? FalseClass
        @body = STRING_FALSE.clone
      end
    end

    def dump
      self.class.dump(self)
    end

    def type_code
      @type & (0x7 << 3)
    end

    def action_code
      @type & 0x7
    end
  end
end
