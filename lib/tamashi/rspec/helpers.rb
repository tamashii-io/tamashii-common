require 'tamashi/packet'

module Tamashi
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

      def tamashi_packet(type, tag, body)
        Tamashi::Packet.new(type, tag, body).dump
      end

      def tamashi_binary_packet(type, tag, body)
        mask = websocket_mask
        packet = tamashi_packet(type, tag, body)
        [0x82, 0x80 + packet.size] + mask + websocket_mask_message(mask, *packet)
      end

      def tamashi_text_packet(type, tag, body)
        mask = websocket_mask
        packet = tamashi_packet(type, tag, body)
        [0x81, 0x80 + packet.size] + mask + websocket_mask_message(mask, *packet)
      end
    end
  end
end
