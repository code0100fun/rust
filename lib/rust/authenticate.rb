require 'capybara'
require 'capybara/dsl'

Capybara.configure { |config|
  config.javascript_driver = :poltergeist
  config.default_driver = :webkit
  config.app_host = "https://#{Rust::Api.host}"
}

module Rust

  class Authenticate
    include Capybara::DSL

    def login username, password
      visit(Rust::Api.login)
      fill_in :credential_0, :with => username
      fill_in :credential_1, :with => password
      click_button 'Login »'
      unless /#{username}/.match(page.body).nil?
        cookies = page.driver.browser.get_cookies
        Rust::Config.cookie = cookies.join('; ')
      end

    end
  end
end
