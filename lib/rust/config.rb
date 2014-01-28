require_relative "./config_file"

module Rust
  class Config

    def delete
      config_file.delete
      @_config_file = nil
    end

    def config_file
      @_config_file ||= Rust::ConfigFile.new
    end

    def options
      @_options ||= config_file.read
    end

    def save
      config_file.write options
      @_options = nil
    end

    def clear_login
      token = cookie = nil
      save
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
      options['cookie']
    end

    def server
      options['server']
    end

    def server= server
      options['server'] = server
    end

    def token
      options['token']
    end

    def token= token
      options['token'] = token
      save
    end

  end
end
