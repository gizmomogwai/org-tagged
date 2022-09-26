Feature: Basics
  Scenario: Table without tag inheritance
    Given I open file "features/data/test-basic.org"
    When I place the cursor before "BEGIN: tagged"
    And I press "C-c C-c"
    Then I should see:
      """
      | Col1      | tag1  | Col1                 | tag2  |
      |-----------+-------+----------------------+-------|
      | 12345678… | 1234… | 12345678901234567890 | 1234… |
      |           |       |                      | todo… |
      | Issue 6 … | Issu… | Issue 6 subtask      |       |
      | Tree      | Tree  | Tree                 |       |
      | Subtree   | Subt… | Subtree              |       |
      """

  Scenario: Table with tag inheritance
    Given I open file "features/data/test-proj.org"
    When I place the cursor before "BEGIN: tagged"
    And I press "C-c C-c"
    Then I should see:
      """
      | tag1      |
      |-----------|
      | project 1 |
      """
