require 'aruba/cucumber'
require 'aruba/in_process'
require 'cucumber/rspec/doubles'
require_relative '../../lib/rust'

Aruba::InProcess.main_class = Rust::Cli
Aruba::process = Aruba::InProcess

