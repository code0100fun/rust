require 'net/http'
require 'json'
require_relative './api'

module Rust

  class Session

    class << self

      def create username, password
        Rust::Api.post(:login) do |req|
          req.set_form_data form(username, password)
        end
      end

      private

      def form username, password
        {
          credential_0: username,
          credential_1: password,
          destination: Rust::Api.logged_in
        }
      end

    end
  end
end
