Feature: Basics
  Scenario: Table without tag inheritance
    Given I open file "features/data/test-basic.org"
    When I place the cursor before "BEGIN: tagged"
    And I press "C-c C-c"
    Then I should see:
      """
      | Col1      | tag1  | Col1                 | tag2  |
      |-----------+-------+----------------------+-------|
      | [[*12345678901234567890][12345678…]] | [[*12345678901234567890][1234…]] | [[*12345678901234567890][12345678901234567890]] | [[*12345678901234567890][1234…]] |
      |           |       |                      | [[*todo2_2][todo…]] |
      | [[*Issue 6 subtask][Issue 6 …]] | [[*Issue 6 subtask][Issu…]] | [[*Issue 6 subtask][Issue 6 subtask]]      |       |
      | [[*Tree][Tree]]      | [[*Tree][Tree]]  | [[*Tree][Tree]]                 |       |
      | [[*Subtree][Subtree]]   | [[*Subtree][Subt…]] | [[*Subtree][Subtree]]              |       |
      """

  Scenario: Table with tag inheritance
    Given I open file "features/data/test-proj.org"
    When I place the cursor before "BEGIN: tagged"
    And I press "C-c C-c"
    Then I should see:
      """
      | tag1      |
      |-----------|
      | [[*project 1][project 1]] |
      """
