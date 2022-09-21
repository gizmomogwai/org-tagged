;;; org-tagged.el --- dynamic block for tagged org-mode todos. -*- lexical-binding: t -*-
;; Copyright (C) 2022 Christian Köstlin

;; This file is NOT part of GNU Emacs.

;; Author: Christian Köstlin <christian.koestlin@gmail.com>
;; Keywords: org-mode, org, gtd, tools
;; Package-Requires: ((s) (dash "2.17.0") (emacs "24.4") (org "9.1"))
;; Package-Version: 0.0.1
;; Homepage: http://gitlab.com/gizmomogwai/org-tagged

;;; Commentary:
;; To create a tagged table for an org file, simply put the dynamic block
;; `
;; #+BEGIN: tagged :tags "tag1|tag2"
;; #+END:
;; '
;; somewhere and run `C-c C-c' on it.

;;; Code:
(require 's)
(require 'dash)
(require 'org)
(require 'org-table)

(defun org-tagged//map ()
  "Map one todoitem to the needed information.
Return a list with
- the heading
- the tag."
  (list
    (nth 4 (org-heading-components))
    (s-chop-right 1 (s-chop-left 1 (nth 5  (org-heading-components))))))

(defun org-tagged//row-for (todo tags)
  "TODO is a list of heading and tag (only one tag allowed).
TAGS are all tags interesting for the table."
  (let*
    (
      (heading (nth 0 todo))
      (tag (nth 1 todo))
      (index (-elem-index tag tags))
      (prefix (s-repeat (1+ index) "|"))
      (suffix (s-repeat (- (length tags) index) "|"))
      )
    (format "%s%s%s" prefix heading suffix)))

(defun org-tagged/version ()
  "Print org-tagge version."
  (interactive)
  (message "org-tagged 0.0.1"))

;;;###autoload
(defun org-dblock-write:tagged (params)
  "Create a tagged dynamic block.
PARAMS must contain: `:tags`."
  (insert
    (let*
      (
        (tags (s-split "|" (plist-get params :tags)))
        (table-title (s-join "|" tags))
        (todos (org-map-entries 'org-tagged//map table-title))
        (row-for (lambda (todo) (org-tagged//row-for todo tags)))
        (table (s-join "\n" (-map row-for todos)))
        )
      (format "|%s|\n|--|\n%s" table-title table)))
  (org-table-align))
(provide 'org-tagged)
;;; org-tagged.el ends here
