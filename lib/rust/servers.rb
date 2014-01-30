require 'net/http'
require 'json'
require_relative './api'

module Rust

  class Servers

    class << self

      def fetch
        result = Rust::Api.post(:servers) do |req|
          req.set_form_data form
        end
        config.servers = result["servers"].map { |s| s["serverid"] }
      end

      private

      def config
        @_config ||= Rust::Config.new
      end

      def form
        {
          accountserviceid: config.account_service_id,
          cftoken: config.token
        }
      end

    end
  end
end
