require 'spec_helper'
require 'securerandom'
require_relative '../lib/rust/config'
require_relative '../lib/rust/authenticate'

describe Rust::Authenticate do
  let(:auth) { Rust::Authenticate.new }
  let(:config) { Rust::Config.new }

  before do
    path = "config/#{SecureRandom.hex(7)}_config.yml"
    @filename = File.expand_path(path, File.dirname(__FILE__))
    config.stub(:file_name).and_return(@filename)
  end

  describe "#login" do
    it "connects to ClanForge and authenticates" do
      # auth.login 'ozone1015@gmail.com', ''
      expect(config.cookie).to_not be_nil
    end
  end

end
