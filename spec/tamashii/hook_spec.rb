require 'spec_helper'

RSpec.describe Tamashii::Hook do

  let(:dummy_env)  { {} }

  subject { described_class.new(dummy_env) }
  it "stores config" do
    expect(subject.env).to eq dummy_env
  end

  it "respond to call but raise not implement error" do
    expect(subject).to respond_to :call
    expect { subject.call("") }.to raise_error(NotImplementedError)
  end
end
