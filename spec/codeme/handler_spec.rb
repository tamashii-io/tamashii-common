require 'spec_helper'

RSpec.describe Codeme::Handler do

  let(:dummy_type) { 1 }
  let(:dummy_env)  { {} }

  subject { described_class.new(dummy_type, dummy_env) }
  it "stores type and config" do
    expect(subject.type).to eq dummy_type
    expect(subject.env).to eq dummy_env
  end

  it "respond to resolve but raise not implement error" do
    expect(subject).to respond_to :resolve
    expect { subject.resolve("") }.to raise_error(NotImplementedError)
  end
end
