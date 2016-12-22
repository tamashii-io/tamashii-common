require 'spec_helper'

RSpec.describe Codeme::Enviromnent do
  let(:env) { nil }
  let(:options) { {} }
  subject { described_class.new(env, options) }

  it "default use development environment" do
    expect(subject.development?).to be true
  end

  it "can detect environment from RACK_ENV" do
    expect(ENV).to receive(:[]).with("RACK_ENV").and_return("production")
    expect(subject.production?).to be true
  end

  it "can convert to environment string" do
    expect(subject.to_s).to eq("development")
  end

  it "can direct compare with string" do
    expect(subject).to eq("development")
  end

  context "production environment" do
    let(:env) { "production" }
    it "can change environement" do
      expect(subject.production?).to be true
    end
  end
end
