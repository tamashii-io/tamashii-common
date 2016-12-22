$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "codeme/common"

require 'simplecov'

SimpleCov.start do
  filters.clear
  add_filter do |src|
    !(src.filename =~ /^#{SimpleCov.root}/) unless src.filename =~ /codeme/
  end
end
