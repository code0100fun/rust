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
      @_config_file.delete unless @_config_file.nil?
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

    def cookies
      options['cookies'] || {}
    end

    def cookies= cookies
      save options.tap {|o| o['cookies'] = cookies}
    end

    def add_cookies cookies
      cookies = self.cookies.merge!(cookies)
      self.cookies = cookies
    end

    def cookie
      cookies.map {|k,v| "#{k}=#{v}" }.join('; ')
    end

    def server
      servers.first
    end

    def servers
      options['servers']
    end

    def servers= servers
      options = self.options
      options['servers'] = servers
      save options
    end

    def token
      options['token']
    end

    def token= token
      save options.tap {|o| o['token'] = token}
    end

    def user
      options['user']
    end

    def user= user
      save options.tap {|o| o['user'] = user}
    end

    def account_service_id
      user['accountservices'].first['accountserviceid']
    end

  end
end
