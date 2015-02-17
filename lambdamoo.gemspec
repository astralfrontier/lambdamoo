# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'lambdamoo/version'

Gem::Specification.new do |spec|
  spec.name          = "lambdamoo"
  spec.version       = Lambdamoo::VERSION
  spec.authors       = ["Bill Garrett"]
  spec.email         = ["garrett@astralfrontier.org"]
  spec.summary       = %q{An implementation of several LambdaMOO features in Ruby.}
  spec.description   = %q{This gem includes a parser and runtime for the LambdaMOO programming language.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 1.9'

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "whittle"
end
