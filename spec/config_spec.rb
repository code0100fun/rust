require 'spec_helper'
require 'securerandom'
require_relative '../lib/rust/config'

describe Rust::Config do
  let(:config) { Rust::Config.new }

  before do
    path = "config/#{SecureRandom.hex(7)}_config.yml"
    @filename = File.expand_path(path, File.dirname(__FILE__))
    config.stub(:file_name).and_return(@filename)
  end

  after do
    config.delete
  end

  describe "#options" do
    it "has empty hash when no options have been set" do
      expect(config.options).to be_a(Hash)
      expect(config.options).to be_empty
    end
  end

  describe "#save" do
    it "writes options to config file" do
      config.options['foo'] = 'bar'
      config.save
      expect(config.options).to eq({'foo' => 'bar'})
    end
  end

  describe "#token" do
    context "token has been set" do
      it "returns the token" do
        config.token = 'foo'
        expect(config.token).to eq('foo')
      end
    end

    context "token has not been set" do
      it "returns the token" do
        expect(config.token).to eq(nil)
      end
    end
  end
end
