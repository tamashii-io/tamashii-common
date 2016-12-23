require 'spec_helper'

RSpec.describe Codeme::Logger do

  LOGGER_FORMAT = /\[[0-9\-\:\s]+\]\s(INFO|DEBUG|WARN|ERROR|FATAL|UNKNOWN)(\s--\s.+?){,1}\t:(.+?)\n/

  let(:path) { STDOUT }
  subject { described_class.new(path) }

  shared_examples "general logger" do
    let(:log_file) { Tempfile.new }
    let(:path) { log_file.path }
    after { log_file.close }
    let(:severity) { :info }

    it "print formatted message" do
      subject.send(severity, "Hello World")
      expect(log_file.read).to match(LOGGER_FORMAT)
    end

    it "has progname" do
      subject.send(severity, "Agent") { "Hello World" }
      expect(log_file.read).to match(/Agent/)
    end

    it "has no progname" do
      subject.send(severity, "Hello World")
      expect(log_file.read).not_to match(/--/)
    end

    it "print message with options" do
      subject.send(severity, "Hello, %{name}", name: "World")
      expect(log_file.read).to match(/World/)
    end

    it "print message from block" do
      subject.send(severity) { "Hello World" }
      expect(log_file.read).to match(LOGGER_FORMAT)
    end

    it "print correct severity tag" do
      subject.send(severity, "Hello World")
      expect(log_file.read).to match(/#{severity.upcase}/)
    end
  end

  it "has default schema" do
    expect(subject.schema).to eq(Codeme::Logger::Colors::SCHEMA[STDOUT])
  end

  describe "#info" do
    it_behaves_like "general logger"
  end

  describe "#debug" do
    it_behaves_like "general logger" do
      let(:severity) { :debug }
    end
  end

  describe "#warn" do
    it_behaves_like "general logger" do
      let(:severity) { :warn }
    end
  end

  describe "#error" do
    it_behaves_like "general logger" do
      let(:severity) { :error }
    end
  end

  describe "#fatal" do
    it_behaves_like "general logger" do
      let(:severity) { :fatal }
    end
  end

  describe "#unknown" do
    it_behaves_like "general logger" do
      let(:severity) { :unknown }
    end
  end

end
