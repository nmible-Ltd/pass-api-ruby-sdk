# frozen_string_literal: true

require_relative "lib/pass/version"

Gem::Specification.new do |spec|
  spec.name = "pass-api-ruby-sdk"
  spec.version = PASS::VERSION
  spec.authors = ["Omar Qureshi"]
  spec.email = ["omar@omarqureshi.net"]

  spec.summary = "PASS API Ruby SDK"
  spec.description = "SDK for interacting with the PASS API"
  spec.homepage = "https://www.nmible.com/"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.add_dependency 'faraday', '2.12.1'
  spec.add_dependency 'jwt', '2.9.3'
  spec.add_dependency 'activesupport', '8.0.0'
  spec.add_dependency 'activemodel', '8.0.0'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
