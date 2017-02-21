require 'spec_helper'

class DummyHandler < Tamashii::Handler
  def resolve(data)
    [data, @env]
  end
end

1.upto(3) do |i|
  eval <<-EOS
class DummyHook#{i} < Tamashii::Hook
  def call(pkt)
    #{i}
  end
end
  EOS

end

RSpec.describe Tamashii::Resolver do

  let(:type) { 1 }
  let(:tag) { 2 }
  let(:body) { "" }
  let(:handler_class) { DummyHandler }
  let!(:packet_obj) { Tamashii::Packet.new(type, tag, body) }
  
  let(:default_env) { {} }
  let(:resolve_env) { {resolve: "value"} }
  

  describe "#config" do
    it "can receive a block with handle" do
      given_type = type
      given_handler_class = handler_class
      subject.config do
        handle(given_type, given_handler_class)
      end
      expect(subject.resolve(packet_obj)).to eq [packet_obj.body, default_env]
    end
  end

  describe "#handle" do
    context "given handler does not implement resolve" do
      let(:handler_class) { NilClass }
      it do
        expect{subject.handle(type, handler_class)}.to raise_error(NotImplementedError)
      end
    end

    it "resolve a packet that match the type" do
      subject.handle(type, handler_class)
      expect(subject.resolve(packet_obj, resolve_env)).to eq [packet_obj.body, default_env.merge(resolve_env)]
    end

    describe "extra env" do
      let(:extra_env) { {foo: "bar"} }
      it "can send extra options when handle" do
        subject.handle(type, handler_class, extra_env)
        expect(subject.resolve(packet_obj, resolve_env)).to eq [packet_obj.body, default_env.merge(resolve_env).merge(extra_env)]
      end
    end
  end
  
  describe "#hook" do
    context "given callback does not implement call" do
      it do
        expect{subject.hook(NilClass, {})}.to raise_error(NotImplementedError)
      end
    end
  end
  
  describe "#default_handler" do
    let(:extra_env) { {foo: "bar"} }
    it "use default handler if no handler set" do
      subject.default_handler(handler_class, extra_env)
      expect(subject.resolve(packet_obj, resolve_env)).to eq [packet_obj.body, default_env.merge(resolve_env).merge(extra_env)]
    end
  end

  describe "#handle?" do
    it "can check if a type is handled" do
      expect(subject.handle?(type)).to be false
      subject.handle(type, handler_class)
      expect(subject.handle?(type)).to be true
    end
  end

  describe "#resolve" do
    it "resolve a packet that match the type" do
      subject.handle(type, handler_class)
      expect(subject.resolve(packet_obj, resolve_env)).to eq [packet_obj.body, default_env.merge(resolve_env)]
    end
    
    let(:hook1){ DummyHook1 }
    let(:hook2){ DummyHook2 }
    let(:hook3){ DummyHook3 }

    context "when hooks does not stop procedure" do
      before do
        subject.hook(hook1)
        subject.hook(hook2)
        subject.hook(hook3)
        subject.handle(type, handler_class)
        expect_any_instance_of(hook1).to receive(:call).and_return(false)
        expect_any_instance_of(hook2).to receive(:call).and_return(false)
        expect_any_instance_of(hook3).to receive(:call).and_return(false)
      end

      it "should call all hooks" do
        subject.resolve(packet_obj, resolve_env)
      end

      it "should call handlers" do
        expect_any_instance_of(handler_class).to receive(:resolve)
        subject.resolve(packet_obj, resolve_env)
      end
    end

    context "when some hook stops the procedure" do
      before do
        subject.hook(hook1)
        subject.hook(hook2)
        subject.hook(hook3)
        subject.handle(type, handler_class)
        expect_any_instance_of(hook1).to receive(:call).and_return(false)
        expect_any_instance_of(hook2).to receive(:call).and_return(true)
        expect_any_instance_of(hook3).not_to receive(:call)
      end
      it "only calls hooks before that one" do
        subject.resolve(packet_obj, resolve_env)
      end

      it "does not call handler#resolve" do
        expect_any_instance_of(handler_class).not_to receive(:resolve)
        subject.resolve(packet_obj, resolve_env)
      end
    end
  end
end
