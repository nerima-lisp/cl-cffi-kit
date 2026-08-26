;;;; t/version-test.lisp
(in-package #:cl-cffi-kit/test)

(describe
  "library-version"
  (it "reports its own version, matching the .asd :version"
    (expect (library-version) :to-equal "0.1.0")))
