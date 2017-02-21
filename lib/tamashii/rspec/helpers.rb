require 'tamashii/packet'

module Tamashii
  module RSpec
    module Helpers
      def websocket_mask
        (1..4).map { rand 255 }
      end

      def websocket_mask_message(mask, *bytes)
        output = []
        bytes.each_with_index do |byte, i|
          output[i] = byte ^ mask[i % 4]
        end
        output
      end

      def tamashii_packet(type, tag, body)
        Tamashii::Packet.new(type, tag, body).dump
      end

      def tamashii_binary_packet(type, tag, body)
        mask = websocket_mask
        packet = tamashii_packet(type, tag, body)
        [0x82, 0x80 + packet.size] + mask + websocket_mask_message(mask, *packet)
      end

      def tamashii_text_packet(type, tag, body)
        mask = websocket_mask
        packet = tamashii_packet(type, tag, body)
        [0x81, 0x80 + packet.size] + mask + websocket_mask_message(mask, *packet)
      end
    end
  end
end
