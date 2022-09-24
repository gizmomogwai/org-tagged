;;; org-tagged.el --- Dynamic block for tagged org-mode todos -*- lexical-binding: t -*-
;; Copyright (C) 2022 Christian Köstlin

;; This file is NOT part of GNU Emacs.

;; Author: Christian Köstlin <christian.koestlin@gmail.com>
;; Keywords: org-mode, org, gtd, tools
;; Package-Requires: ((s "1.13.0") (dash "2.19.1") (emacs "28.1") (org "9.5.2"))
;; Package-Version: 0.0.3
;; Homepage: http://github.com/gizmomogwai/org-tagged

;;; Commentary:
;; To create a tagged table for an org file, simply put the dynamic block
;; `
;; #+BEGIN: tagged :columns "%10tag1(Tag1)|tag2" :match "kanban"
;; #+END:
;; '
;; somewhere and run `C-c C-c' on it.

;;; Code:
(require 's)
(require 'dash)
(require 'org)
(require 'org-table)

(defun org-tagged--get-data-from-heading ()
  "Extract the needed information from a heading.
Return a list with
- the heading
- the tags as list of strings."
  (list
    (nth 4 (org-heading-components))
    (remove "" (s-split ":" (nth 5 (org-heading-components))))))

(defun org-tagged--row-for (heading item-tags columns)
  "Create a row for a HEADING and its ITEM-TAGS for a table with COLUMNS."
  (let ((result  (format "|%s|" (s-join "|"
    (--map
      (if (-elem-index (nth 1 it) item-tags)
        (s-truncate (nth 0 it) heading)
        "")
      columns)))))
    (if (eq (length result) (1+ (length columns))) nil result)))

(defun org-tagged-version ()
  "Print org-tagge version."
  (interactive)
  (message "org-tagged 0.0.3"))

(defun org-tagged--parse-column (column-description)
  "Parse a column from a COLUMN-DESCRIPTION.
Each column description consists of:
- maximum length (defaults to 1000)
- tag to select the elements that go into the column
- title of the column (defaults to the tag)"
  (string-match
    (rx
      string-start
      (optional (and "%" (group (one-or-more digit))))
      (group (minimal-match (1+ anything)))
      (optional (and "(" (group (+? anything)) ")"))
      string-end)
    column-description)
  (list
    (string-to-number (or (match-string 1 column-description) "1000"))
    (match-string 2 column-description)
    (or (match-string 3 column-description) (match-string 2 column-description))))

;(org-tagged--parse-column "%25tag1(Column1)")
;(org-tagged--parse-column "tag1(ttt)")
;(org-tagged--parse-column "tag1")
;(org-tagged--parse-column "%25tag1")

(defun org-tagged--get-columns (columns-description)
  "Parse the column descriptions out of COLUMNS-DESCRIPTION.
The columns are separated by `|'."
  (--map (org-tagged--parse-column it) (s-split "|" columns-description)))

;(org-tagged--get-columns "%25tag1(Column1)|tag2|tag3")

;;;###autoload
(defun org-dblock-write:tagged (params)
  "Create a tagged dynamic block.
PARAMS must contain: `:tags`."
  (insert
    (let*
      (
        (columns
          (org-tagged--get-columns (plist-get params :columns)))
        (todos
          (org-map-entries 'org-tagged--get-data-from-heading (plist-get params :match)))
        (table
          (s-join "\n" (remove nil (--map (org-tagged--row-for (nth 0 it) (nth 1 it) columns) todos)))))
      (format "|%s|\n|--|\n%s" (s-join "|" (--map (nth 2 it) columns)) table)))
  (org-table-align))
(provide 'org-tagged)
;;; org-tagged.el ends here

