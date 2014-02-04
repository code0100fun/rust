Feature: Logging in
  Scenario: Provide login credentials
    Given the config directory is set
    And I have no cached login credentials
    When I run `rust` interactively
    Then the output should contain:
      """
      Multiplay email >
      """

