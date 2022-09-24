Feature: Basics
  Background:
    Given I open file "features/data/test1.org"
    When I place the cursor before "BEGIN: tagged"
    And I press "C-c C-c"

  Scenario: Basic table
    Then I should see:
      """
      #+BEGIN: tagged :columns "%9tag1(Col1)|%5tag1|tag1(Col1)|%5tag2" :match "kanban"
      | Col1      | tag1  | Col1                 | tag2  |
      |-----------+-------+----------------------+-------|
      | 123456... | 12... | 12345678901234567890 | 12... |
      |           |       |                      | to... |
      | Issue ... | Is... | Issue 6 subtask      |       |
      #+END:
      """
