(defpackage #:cl-cffi-kit/test
  (:use #:cl)
  (:shadowing-import-from #:cl-weave #:describe)
  (:import-from #:cl-weave
                #:it #:expect #:signals #:run-all #:defmatcher
                #:it-property #:it-sequential #:gen-string
                #:run-mutations #:assert-mutation-score
                #:it-each #:describe-concurrent
                #:spy-on #:mock-restore #:mock-calls #:around-each)
  (:import-from #:cffi #:mem-ref #:foreign-string-alloc)
  (:import-from #:cl-cffi-kit
                #:library-version #:cl-cffi-kit-error
                #:call-with-foreign-object #:with-foreign-object
                #:call-with-foreign-objects #:with-foreign-objects
                #:call-with-foreign-string #:with-foreign-string
                #:foreign-string-to-lisp #:foreign-string-free
                #:check-foreign-error #:with-checked-foreign-call
                #:foreign-call-error #:foreign-call-error-function
                #:foreign-call-error-code)
  (:export #:run-tests))

(in-package #:cl-cffi-kit/test)

;; Macro expansion helpers are ordinary functions so SB-COVER can instrument
;; and test the expansion logic.
(defun run-tests (&key (reporter :spec))
  (unless (run-all :reporter reporter
                    :coverage t
                    :coverage-include-pathnames
                    (list (asdf:system-relative-pathname "cl-cffi-kit" "src/"))
                    :coverage-minimum-expression 70
                    :coverage-minimum-branch 90)
    (error "cl-cffi-kit test suite failed"))
  (format t "~&cl-cffi-kit/test: successful completion with 0 failures~%")
  t)
