require 'bundler/setup'
Bundler.require(:default)

require 'json'
require 'active_support/core_ext/string/inflections'

require 'pass/resources'
require 'pass/client'
require 'pass/study'
require 'pass/site'

module PASS
  class << self
  end
end
