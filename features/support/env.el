(require 'org-tagged)
(require 'espuds)
(require 'ert)

(Setup
 ;;(message "Setup")
 ;; Before anything has run
 )

(Before
 ;;(message "Before")
 ;; Before each scenario is run
;; (erase-buffer)
 )

(After
 ;;(message "After")
 ;; After each scenario is run
;; (message "Killing buffer %s" (current-buffer))
 (kill-buffer (current-buffer))
 )

(Teardown
 ;;(message "Teardown")
 ;; After when everything has been run
 )
