require 'spec_helper'

RSpec.describe Codeme::Logger do

  LOGGER_FORMAT = /\[[0-9\-\:\s]+\]\s(INFO|DEBUG|WARN|ERROR|FATAL)\t:(.+?)\n/

  let(:path) { STDOUT }
  subject { described_class.new(path) }

  context "defined path" do
    let(:log_file) { Tempfile.new }
    let(:path) { log_file.path }
    after { log_file.close }

    it "print formatted message" do
      subject.info("Hello World")
      expect(log_file.read).to match(LOGGER_FORMAT)
    end

    it "has default schema" do
      expect(subject.schema).to eq(Codeme::Logger::Colors::SCHEMA[STDOUT])
    end
  end
end
