module Rust
  module SpecHelpers
    def self.included(base)
      def random_filename
        path = "../../tmp/config/#{SecureRandom.hex(7)}_config.yml"
        File.expand_path(path, File.dirname(__FILE__))
      end
      base.let(:filename) { random_filename }
      base.let(:config_filename) { random_filename }

      base.let!(:config_file) { Rust::ConfigFile.new(config_filename) }
      base.let(:config) { Rust::Config.new(filename) }
      base.let(:config2) { Rust::Config.new(filename) }

      base.after(:each) do
        config_file.delete
        config.delete
        config2.delete
      end
    end
  end
end
