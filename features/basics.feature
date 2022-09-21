Feature: Basics
  Background:
    Given I open file "tests/test1.org"
    When I place the cursor before "BEGIN: tagged"
    And I press "C-c C-c"

  Scenario: Basic table
    Then I should see:
      """
      #+BEGIN: tagged :tags "tag1|tag2"
      | tag1    | tag2    |
      |---------+---------|
      | todo1_1 |         |
      |         | todo2_2 |
      |         | todo3_2 |
      | todo4_1 |         |
      #+END:
      """
