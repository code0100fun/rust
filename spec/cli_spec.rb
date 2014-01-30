require 'spec_helper'
require_relative '../lib/rust/config'

describe Rust::Config do

  describe "option sync" do
    it "separate instances see the same config options" do
      config.cookies = {"foo" => "bar"}
      expect(config2.cookies).to eq({"foo" => "bar"})
    end
  end

  describe "#options" do
    it "has empty hash when no options have been set" do
      expect(config.options).to be_a(Hash)
      expect(config.options).to be_empty
    end
  end

  describe "#save" do
    it "writes options to config file" do
      options = config.options
      options['foo'] = 'bar'
      config.save options
      expect(config.options).to eq({'foo' => 'bar'})
    end
  end

  describe "#cookies" do
    context "no cookies are stored" do
      it "returns an empty array" do
        expect(config.cookies).to be_a(Hash)
        expect(config.cookies).to be_empty
      end
    end
  end

  describe "#cookie" do
    it "concatenates cookies into one line" do
      config.cookies = {"foo" => "bar", "baz" => "qux"}
      expect(config.cookie).to eq("foo=bar; baz=qux")
    end
  end

  describe "#cookie" do
    it "concatenates cookies into one line" do
      config.cookies = {"foo" => "bar", "baz" => "qux"}
      expect(config.cookie).to eq("foo=bar; baz=qux")
    end
  end

  describe "#add_cookies" do
    it "concatenates cookies into one line" do
      config.cookies = {"foo" => "bar"}
      config.add_cookies({"baz" => "qux"})
      expect(config.cookies).to eq({"foo" => "bar", "baz" => "qux"})
      expect(config.cookie).to eq("foo=bar; baz=qux")
    end

    it "overwrites old cookie with the same name" do
      config.cookies = {"foo" => "bar"}
      config.add_cookies({"foo" => "baz"})
      expect(config.cookies).to eq({"foo" => "baz"})
      expect(config.cookie).to eq("foo=baz")
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
