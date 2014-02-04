require_relative '../lib/rust'
require 'spec_helper'

describe Rust::Cli do

  describe "login prompt" do
    let(:cli) do
      puts config.filename
      Rust::Cli.any_instance.stub(:config).and_return(config)
      Rust::User.any_instance.stub(:config).and_return(config)
      Rust::Servers.any_instance.stub(:config).and_return(config)
      Rust::Command.any_instance.stub(:config).and_return(config)
      Rust::Cli.new
    end

    before do
      puts config.filename
      fork_reader, @writer = IO.pipe
      @reader, fork_writer = IO.pipe

      puts cli.config.filename
      @pid = fork do
        @reader.close
        @writer.close
        $stdout = fork_writer
        $stdin = fork_reader
        cli.execute!
      end
      puts "start #{@pid}"
      fork_writer.close
      fork_reader.close
    end

    after do
      puts "kill #{@pid}"
      Process.kill("HUP", @pid)
    end

    context "when no cached login info found" do
      xit "asks user fo login information" do
        expect(@reader.gets).to include("You must login to Multiplay")
        @writer.puts "ozone1015@gmail.com"
        expect(@reader.gets).to include("Multiplay Email: ozone1015@gmail.com")
        @writer.puts "manbearpig"
        expect(@reader.gets).to include("Multiplay Password:")
        expect(@reader.gets).to include("Connecting to Multiplay...")
        expect(@reader.gets).to include("Connected")
        expect(@reader.gets).to include("Fetching user data...")
        puts "token: #{config.token}"
        expect(@reader.gets).to include("Successfully logged in as ozone1015@gmail.com")
        expect(@reader.gets).to include("Fetching server lust...")
        expect(@reader.gets).to include("Found 1 servers")
      end
    end
  end

end
