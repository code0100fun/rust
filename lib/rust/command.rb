module Rust
  class Command
    def initialize command_text
      @command_text = command_text
    end

    def run
      req = create_request
      req.set_form_data form
      res = send_request req
      parse_response res
    end

    private

    def parse_response res
      begin
        JSON.parse res.body
      rescue
        { "status" => res.code, "message" => res.message }
      end
    end

    def send_request req
      http = Net::HTTP.new uri.hostname, uri.port
      http.use_ssl = true
      res = http.start do |http|
        http.request req
      end
    end

    def config
      @_config ||= Rust::Config.new
    end

    def create_request
      req = Net::HTTP::Post.new uri
      req.content_type = content_type
      req['Cookie'] = config.cookie
      req['Accept'] = 'application/json'
      req['User-Agent'] = user_agent
      req
    end

    def content_type
      'application/x-www-form-urlencoded; charset=UTF-8'
    end

    def user_agent
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/32.0.1700.77 Safari/537.36'
    end

    def form
      {
        cftoken: config.token,
        lc_console_text: @command_text,
        serverid: config.server
      }
    end

    def uri
      URI "https://#{Rust::Api.host}#{Rust::Api.command}"
    end

  end
end
