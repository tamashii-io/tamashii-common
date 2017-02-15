require 'spec_helper'

RSpec.describe Tamashi::Config do

  it "accept SHARED_CONFIG as config" do
    expect(subject.accept?(Tamashi::Config::SHARED_CONFIG.first)).to be  true
  end

  it "can add new config" do
    subject.register(:new_config)
    expect(subject.accept?(:new_config)).to be true
  end

  it "can set SHARED_CONFIG: auth_type" do
    subject.auth_type = true
    expect(subject.auth_type).to be true
  end

  it "cannot set unregister config" do
    subject.unregister = true
    expect(subject.unregister).to be nil
  end

  it "can set config by method" do
    subject.auth_type true
    expect(subject.auth_type).to be true
  end

  it "can set config by block" do
    subject.auth_type { true }
    expect(subject.auth_type).to be true
  end

  it "can access config when use block" do
    token = SecureRandom.hex(8)
    expect(subject).to receive(:token).with(token)
    subject.auth_type do |config|
      config.token token
      true
    end

    expect(subject.auth_type).to be true
  end

  it "support class level instance" do
    klass = Class.new(Tamashi::Config) do
      register :apple, true
    end
    expect(klass.new.accept?(:apple)).to be true
  end

  it "support class level accessor" do
    klass = Class.new(Tamashi::Config) do
      register :shared, true
    end
    expect(klass[:shared]).to be true
    klass[:shared] = false
    expect(klass[:shared]).to be false
  end

  describe "#env" do
    it "has development as default environment" do
      expect(subject.env.development?).to be true
    end

    it "can set environment" do
      subject.env = "production"
      expect(subject.env.production?).to be true
    end
  end

end
