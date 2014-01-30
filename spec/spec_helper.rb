require 'securerandom'
require_relative './support/global_spec_helpers'
require_relative '../lib/rust/config'

RSpec.configure do |config|
  config.treat_symbols_as_metadata_keys_with_true_values = true
  config.run_all_when_everything_filtered = true
  config.filter_run :focus
  config.order = 'random'
  config.include Rust::SpecHelpers
end

