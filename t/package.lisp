;;;; t/package.lisp
(defpackage #:cl-cffi-kit/test
  (:use #:cl)
  (:shadowing-import-from #:cl-weave #:describe)
  (:import-from #:cl-weave #:it #:expect #:signals #:run-all)
  (:import-from #:cffi #:mem-ref)
  (:import-from #:cl-cffi-kit
                #:library-version #:cl-cffi-kit-error
                #:with-foreign-string #:foreign-string-to-lisp
                #:with-foreign-object #:check-foreign-error
                #:foreign-call-error #:foreign-call-error-function
                #:foreign-call-error-code)
  (:export #:run-tests))

(in-package #:cl-cffi-kit/test)

(defun run-tests (&key (reporter :spec))
  (unless (run-all :reporter reporter :timeout-ms 20000)
    (error "cl-cffi-kit test suite failed"))
  (format t "~&cl-cffi-kit/test: successful completion with 0 failures~%")
  t)
