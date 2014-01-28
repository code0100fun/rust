require 'spec_helper'
require 'securerandom'
require_relative '../lib/rust/config_file'

describe Rust::ConfigFile do
  let(:config) { Rust::ConfigFile }

  before do
    path = "config/#{SecureRandom.hex(7)}_config.yml"
    @filename = File.expand_path(path, File.dirname(__FILE__))
    config.stub(:file_name).and_return(@filename)
  end

  after do
    Rust::ConfigFile.delete
  end

  describe "#create" do
    it "creates the output directory if it does not exist" do
      config.create
      expect(File.exists?(@filename)).to eq(true)
    end
  end

  describe "#read" do
    context "no options stored" do
      it "returns an empty hash" do
        expect(config.read).to be_a(Hash)
        expect(config.read).to be_empty
      end
    end
  end

  describe "#write" do
    context "writing hash with options set" do
      it "writes the options to the file" do
        config.write({foo: 'bar'})
        expect(config.read).to eq({foo: 'bar'})
      end
    end
  end

end
