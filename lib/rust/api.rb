require 'cgi'

module Rust
  class Api
    class << self

      def command_uri
        URI "https://#{Rust::Api.host}#{Rust::Api.command}"
      end

      def login_uri
        URI "https://#{host}#{login}"
      end

      def logged_in_uri
        URI "https://#{host}#{logged_in}"
      end

      def servers_uri
        URI "https://#{host}#{servers}"
      end

      def host
        'clanforge.multiplay.co.uk'
      end

      def login
        '/cf/LOGIN'
      end

      def logged_in
        '/cf/v1/loggedin'
      end

      def servers
        '/cf/v1/servers'
      end

      def command
        '/cf/v1/livecontrol/console_send'
      end

      def get uri, &block
        request :get, uri, &block
      end

      def post uri, &block
        request :post, uri, &block
      end

      def symbol_to_uri sym
        method = "#{sym}_uri".to_sym
        uri = send(method)
      end

      def parse_cookie cookie
        cookie = cookie.split(';').first.split('=')
        cookie_hash = {}
        cookie_hash[cookie[0]] = cookie[1]
        cookie_hash
      end

      def request method, uri
        uri = symbol_to_uri(uri)
        req = http_methods[method].new uri
        configure_request req
        yield(req) if block_given?
        res = send_request req
        cookie = res.get_fields('Set-Cookie')
        unless cookie.nil?
          cookie = cookie.first
          cookie = parse_cookie cookie
          config.add_cookies cookie
        end
        begin
          JSON.parse res.body
        rescue
          { "status" => res.code, "message" => res.message }
        end
      end

      private

      def http_methods
        { get: Net::HTTP::Get, post: Net::HTTP::Post }
      end

      def send_request req
        http = Net::HTTP.new req.uri.hostname, req.uri.port
        http.use_ssl = true
        http.start do |http|
          http.request req
        end
      end

      def configure_request req
        req['Cookie'] = config.cookie
        req['User-Agent'] = user_agent
        req
      end

      def user_agent
        'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36'
      end

      def config
        @_config ||= Rust::Config.new
      end

    end
  end
end
