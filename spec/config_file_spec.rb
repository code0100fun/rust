require 'spec_helper'
require 'securerandom'
require_relative '../lib/rust/config_file'

describe Rust::ConfigFile do

  describe "#create" do
    it "creates the output directory if it does not exist" do
      config_file.create
      expect(File.exists?(config_filename)).to eq(true)
    end
  end

  describe "#read" do
    context "no options stored" do
      it "returns an empty hash" do
        expect(config_file.read).to be_a(Hash)
        expect(config_file.read).to be_empty
      end
    end
  end

  describe "#write" do
    context "writing hash with options set" do
      it "writes the options to the file" do
        config_file.write({foo: 'bar'})
        expect(config_file.read).to eq({foo: 'bar'})
      end
    end
  end

end
