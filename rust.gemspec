# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rust/version'

Gem::Specification.new do |spec|
  spec.name          = "rust"
  spec.version       = Rust::VERSION
  spec.authors       = ["Chase McCarthy"]
  spec.email         = ["chase@code0100fun.com"]
  spec.summary       = %q{A Rust server admin library.}
  spec.description   = %q{Works by sending commands to ClanForge's console endpoint.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = ['rust']
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_runtime_dependency "highline"
  spec.add_runtime_dependency "rb-readline"
  spec.add_runtime_dependency "active_support"
  spec.add_runtime_dependency "colorize"
end
