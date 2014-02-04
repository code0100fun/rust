module Rust
  class Command

    def initialize command_text
      @command_text = command_text
    end

    def run
      Rust::Api.post(:command) do |req|
        req.set_form_data form
      end
    end

    private

    include Rust::Configurable

    def form
      {
        cftoken: config.token,
        lc_console_text: @command_text,
        serverid: config.server
      }
    end

  end
end
