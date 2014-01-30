require 'net/http'
require 'json'
require_relative './api'

module Rust

  class User

    class << self

      def fetch
        result = Rust::Api.get(:logged_in)
        require 'pry'; binding.pry
        config.token = result["cftoken"]
        config.user = result["user"]
      end

      private

      def config
        @_config ||= Rust::Config.new
      end

    end
  end
end
