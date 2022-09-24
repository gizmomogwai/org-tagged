(require 'org-tagged)

(ert-deftest org-tagged-test-parse-column ()
  (should (equal (org-tagged--parse-column "%25tag1(Column1)") '(25 "tag1" "Column1")))
  (should (equal (org-tagged--parse-column "tag1(Column1)") '(1000 "tag1" "Column1")))
  (should (equal (org-tagged--parse-column "tag1") '(1000 "tag1" "tag1")))
  (should (equal (org-tagged--parse-column "%25tag1") '(25 "tag1" "tag1")))
  )

(ert-deftest org-tagged-test-parse-columns ()
  (should
    (equal
      (org-tagged--get-columns "%25tag1(Column1)|tag2|tag3")
      (list (list 25 "tag1" "Column1") (list 1000 "tag2" "tag2") (list 1000 "tag3" "tag3"))))
  )
