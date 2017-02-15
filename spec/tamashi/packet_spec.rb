require 'spec_helper'

RSpec.describe Tamashi::Packet do

  let(:type_code) { 1 } 
  let(:action_code) { 2 }
  let(:type) { type_code << 3 | action_code }
  let(:type_bytes) { [type] }
  let(:tag) { 2 }
  let(:tag_bytes) { [0, 2] }
  let(:body) { "aaa" }
  let(:body_bytes) { ["a".ord] * 3 }
  let(:size_bytes) { [0, 3] }
  let!(:packet_obj) { described_class.new(type, tag, body) }

  describe "class methods" do
    describe ".dump" do
      context "correct case" do
        describe "can dump true class" do
          let(:body) { true }
          let(:size_bytes) { [0, 1] }
          let(:body_bytes) { ["0".ord] }
          it do
            bytes = type_bytes + tag_bytes + size_bytes +  body_bytes
            expect(described_class.dump(packet_obj)).to eq bytes
          end
        end

        describe "can dump false class" do
          let(:body) { false }
          let(:size_bytes) { [0, 1] }
          let(:body_bytes) { ["1".ord] }
          it do
            bytes = type_bytes + tag_bytes + size_bytes +  body_bytes
            expect(described_class.dump(packet_obj)).to eq bytes
          end
        end

        it "can dump string" do
          bytes = type_bytes + tag_bytes + size_bytes +  body_bytes
          expect(described_class.dump(packet_obj)).to eq bytes
        end
      end

      context "error packet" do
        let(:packet_obj) { "" } 
        it "raise type error" do
          expect { described_class.dump(packet_obj) }.to raise_error(TypeError)
        end
      end

      context "error body" do
        let(:body) { 1 }
        it "raise type error" do
          expect { described_class.dump(packet_obj) }.to raise_error(TypeError)
        end
      end
    end

    it "can load" do
      bytes = type_bytes + tag_bytes + size_bytes + body_bytes
      loaded_packet = described_class.load(bytes)
      expect(loaded_packet.type).to eq packet_obj.type
      expect(loaded_packet.tag).to eq packet_obj.tag
      expect(loaded_packet.body).to eq packet_obj.body
    end
    
    it "can combine integer" do
      n1 = rand(256)
      n2 = rand(256)
      expect(described_class.combine_integer([n1, n2])).to eq (n1 << 8 | n2)
    end

    it "can split integer" do
      n1 = rand(256)
      n2 = rand(256)
      n = n1 << 8 | n2
      expect(described_class.split_integer(n, 2)).to eq [n1, n2]
    end
  end

  describe "instance methods" do
    describe "can do body conversion" do
      let(:body) { true }
      it "convert true class into 0" do
        expect(packet_obj.body).to eq "0"
      end
    end
    it "can dump itself using class method .dump" do
      expect(packet_obj.dump).to eq described_class.dump(packet_obj)
    end
    it "can extract the type code" do
      expect(packet_obj.type_code).to eq type_code << 3
    end
    it "can extract the action code" do
      expect(packet_obj.action_code).to eq action_code
    end
  end
end
