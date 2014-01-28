module Rust
  class Api
    class << self

      def login
        '/login'
      end

      def host
        'clanforge.multiplay.co.uk'
      end

      def command
        '/cf/v1/livecontrol/console_send'
      end

    end
  end
end
