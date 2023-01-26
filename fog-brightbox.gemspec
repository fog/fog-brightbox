# coding: utf-8

lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "fog/brightbox/version"

Gem::Specification.new do |spec|
  spec.name          = "fog-brightbox"
  spec.version       = Fog::Brightbox::VERSION
  spec.authors       = ["Paul Thornthwaite"]
  spec.email         = ["tokengeek@gmail.com"]
  spec.description   = "Module for the 'fog' gem to support Brightbox Cloud"
  spec.summary       = "This library can be used as a module for `fog` or as standalone provider
                        to use the Brightbox Cloud in applications"
  spec.homepage      = "https://github.com/fog/fog-brightbox"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 2.0"

  spec.add_dependency "fog-core", ">= 1.45", "< 3.0"
  spec.add_dependency "fog-json"
  spec.add_dependency "dry-inflector"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rubocop", "< 0.50"
  spec.add_development_dependency "shindo"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "yard"
end
