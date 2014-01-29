require 'spec_helper'
require 'securerandom'
require_relative '../lib/rust/config'
require_relative '../lib/rust/authenticate'

describe Rust::Authenticate do
  let(:auth) { Rust::Authenticate.new }
  let(:filename) do
    path = "config/#{SecureRandom.hex(7)}_config.yml"
    File.expand_path(path, File.dirname(__FILE__))
  end
  let(:config) { Rust::Config.new(filename) }

  before do
    path = "config/#{SecureRandom.hex(7)}_config.yml"
    @filename = File.expand_path(path, File.dirname(__FILE__))
    config.stub(:file_name).and_return(@filename)
  end

  describe "#login" do
    xit "connects to ClanForge and authenticates" do
      auth.login 'ozone1015@gmail.com', ''
      expect(config.cookie).to_not be_nil
    end
  end

end
