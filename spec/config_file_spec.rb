require 'spec_helper'
require_relative '../lib/rust/config_file'

describe Rust::ConfigFile do
  let(:filename){ File.expand_path("config/config.yml", File.dirname(__FILE__)) }
  before do
    Rust::ConfigFile.stub(:file_name).and_return(filename)
  end
  after do
    # Rust::ConfigFile.delete
  end
  describe "#create" do
    it "creates the output directory if it does not exist" do
      Rust::ConfigFile.create
      expect(File.exists?(filename)).to eq(true)
    end
  end
end
