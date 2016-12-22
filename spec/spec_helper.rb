$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'simplecov'

SimpleCov.start do
  add_filter "/spec/"
  track_files "lib/**/*.rb"
end

require "codeme/common"
