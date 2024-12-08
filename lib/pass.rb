require 'bundler/setup'
Bundler.require(:default)

require 'json'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'

require 'pass/resources'
require 'pass/resource'
require 'pass/client'
require 'pass/country'
require 'pass/language'
require 'pass/study'
require 'pass/arm'
require 'pass/site'
require 'pass/participant'
require 'pass/visit'

module PASS
  class << self
  end
end
