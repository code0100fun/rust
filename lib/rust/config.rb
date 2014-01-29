require_relative './config_file'

module Rust
  class Config

    def initialize(filename=nil)
      @filename = filename
    end

    def filename
      config_file.filename
    end

    def delete
      @_config_file.delete
      @_config_file = nil
    end

    def config_file
      @_config_file ||= Rust::ConfigFile.new @filename
    end

    def options
      config_file.read
    end

    def save options
      config_file.write(options)
    end

    def clear_login
      self.token = nil
      self.cookie = nil
    end

    def need_login?
      token.nil? || cookie.nil?
    end

    def need_server?
      server.nil?
    end

    def cookie
      options['cookie']
    end

    def cookie= cookie
      save options.tap {|o| o['cookie'] = cookie}
    end

    def server
      options['server']
    end

    def server= server
      save options.tap {|o| o['server'] = server}
    end

    def token
      options['token']
    end

    def token= token
      save options.tap {|o| o['token'] = token}
    end

  end
end
