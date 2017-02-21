require 'logger'

module Tamashii
  class Logger < ::Logger
    module Colors
      NOTHING      = '0;0'
      BLACK        = '0;30'
      RED          = '0;31'
      GREEN        = '0;32'
      BROWN        = '0;33'
      BLUE         = '0;34'
      PURPLE       = '0;35'
      CYAN         = '0;36'
      LIGHT_GRAY   = '0;37'
      DARK_GRAY    = '1;30'
      LIGHT_RED    = '1;31'
      LIGHT_GREEN  = '1;32'
      YELLOW       = '1;33'
      LIGHT_BLUE   = '1;34'
      LIGHT_PURPLE = '1;35'
      LIGHT_CYAN   = '1;36'
      WHITE        = '1;37'

      SCHEMA = {
        STDOUT => %w[nothing green brown red purple cyan],
        STDERR => %w[nothing green yellow light_red light_purple light_cyan],
      }
    end

    attr_accessor :enable_filter

    FILTER_PARAMS = %i(token password)

    alias format_message_colorless format_message

    def initialize(*args)
      super
      @enable_filter = false
      self.formatter = proc do |severity, datetime, progname, message|
        severity = "UNKNOWN" if severity == "ANY"
        datetime = datetime.strftime("%Y-%m-%d %H:%M:%S")
        progname = " -- #{progname}" if progname
        "[#{datetime}] #{severity}#{progname}\t: #{message}\n"
      end
    end

    def format_message(level, *args)
      if schema[Logger.const_get(level.sub "ANY", "UNKNOWN")].to_s.upcase
        color = begin
                  Logger::Colors.const_get \
                    schema[Logger.const_get(level.sub "ANY", "UNKNOWN")].to_s.upcase
                rescue NameError
                  "0;0"
                end
        "\e[#{ color }m#{ format_message_colorless(level, *args) }\e[0;0m"
      else
        format_message_colorless(level, *args)
      end
    end

    def schema
      Logger::Colors::SCHEMA[@logdev.dev] || Logger::Colors::SCHEMA[STDOUT]
    end

    def filter(progname = nil, **options, &block)
      FILTER_PARAMS.each { |param| options[param] = "FILTERED" if options.include?(param) } if @enable_filter
      if block_given?
        yield
      else
        progname
      end % options
    end

    def info(progname = nil, **options, &block)
      severity = ::Logger.const_get(__callee__.upcase)
      _progname = block_given? ? progname : nil
      add(severity, filter(progname, **options, &block), _progname)
    end

    alias debug info
    alias error info
    alias warn info
    alias fatal info
    alias unknown info
  end
end
