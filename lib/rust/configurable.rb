module Rust
  module Configurable
    extend ActiveSupport::Concern

    def config
      @_config ||= Rust::Config.new
    end
  end
end
