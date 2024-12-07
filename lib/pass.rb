require 'bundler/setup'
Bundler.require(:default)

require 'json'
require 'active_support/core_ext/string/inflections'

require 'pass/client'
require 'pass/study'

module PASS
  class << self
  end
end
