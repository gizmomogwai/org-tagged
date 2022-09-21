
(And "^I run \\(.+\\)$"
     (lambda (function)
       (funcall (intern function))
       ))

(Given "^I open file \"\\([^\"]+\\)\"$"
  (lambda (arg)
    (find-file arg)
    ))
