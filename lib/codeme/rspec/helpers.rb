require 'codeme/packet'

module Codeme
  module RSpec
    module Helpers
      def websocket_mask
        (1..4).map { rand 255 }
      end

      def websocket_mask_message(*bytes)
        output = []
        bytes.each_with_index do |byte, i|
          output[i] = byte ^ mask[i % 4]
        end
        output
      end

      def codeme_packet(type, tag, body)
        Codeme::Packet.new(type, tag, body).dump
      end

      def codeme_binary_packet(type, tag, body)
        packet = codeme_packet(type, tag, body)
        [0x82, 0x80 + packet.size] + websocket_mask + websocket_mask_message(*packet)
      end

      def codeme_text_packet(type, tag, body)
        packet = codeme_packet(type, tag, body)
        [0x81, 0x80 + packet.size] + websocket_mask + websocket_mask_message(*packet)
      end
    end
  end
end
