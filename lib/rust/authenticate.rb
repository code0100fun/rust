require 'capybara'
require 'capybara/dsl'
require 'capybara-webkit'
require_relative './api'

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
  config.default_driver = :webkit
  config.app_host = "https://#{Rust::Api.host}"
end

module Rust

  class Authenticate
    include Capybara::DSL

    def config
      @_config ||= Rust::Config.new
    end
    def login username, password
      visit(Rust::Api.login)
      fill_in :credential_0, :with => username
      fill_in :credential_1, :with => password
      click_button 'Login »'
      unless /#{username}/.match(page.body).nil?
        cookies = page.driver.browser.get_cookies
        config.cookie = cookies.join('; ')
      end

    end
  end
end
