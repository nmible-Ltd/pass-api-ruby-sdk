require 'bundler/setup'
Bundler.require(:default)

require 'json'
require 'ostruct'
require 'active_support/core_ext/string/inflections'
require 'active_support/core_ext/object/blank'

require 'pass/version'
require 'pass/resources'
require 'pass/resource'
require 'pass/client'
require 'pass/country'
require 'pass/language'
require 'pass/currency'
require 'pass/expense_type'
require 'pass/study'
require 'pass/visit_schedule'
require 'pass/arm'
require 'pass/site'
require 'pass/participant'
require 'pass/visit'
require 'pass/micropayment'
require 'pass/participant_visit'

module PASS
  class << self
  end
end
