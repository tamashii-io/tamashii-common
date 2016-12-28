require 'spec_helper'

RSpec.describe Codeme::Handler do

  let(:dummy_type_code) { 1 }
  let(:dummy_action_code) { 2 }
  let(:dummy_env)  { {} }

  subject { described_class.new(dummy_type_code, dummy_env) }
  it "stores type_code and config" do
    expect(subject.type_code).to eq dummy_type_code
    expect(subject.env).to eq dummy_env
  end

  it "respond to resolve but raise not implement error" do
    expect(subject).to respond_to :resolve
    expect { subject.resolve(dummy_action_code) }.to raise_error(NotImplementedError)
  end
end
