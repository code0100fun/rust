require 'spec_helper'
require_relative '../lib/rust/config'

describe Rust::Config do
  let(:filename){ File.expand_path("config/config.yml", File.dirname(__FILE__)) }
  before do
    Rust::ConfigFile.stub(:file_name).and_return(filename)
  end
  after do
    # Rust::ConfigFile.delete
  end
  describe "#options" do
    it "has empty hash when no options have been set" do
      expect(Rust::Config.options).to be_a(Hash)
      expect(Rust::Config.options).to be_empty
    end
  end
end
