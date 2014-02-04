require 'net/http'
require 'json'
require_relative './api'

module Rust

  class User

    class << self

      def fetch
        result = Rust::Api.get(:logged_in)
        config.token = result["cftoken"]
        config.user = result["user"]
        puts config.filename
      end

      private

      include Rust::Configurable

    end
  end
end
