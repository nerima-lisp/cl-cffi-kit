;;;; cl-cffi-kit.asd
(in-package #:asdf-user)

(defsystem "cl-cffi-kit"
  :description "Common Lisp toolkit for safer, more ergonomic CFFI foreign-function usage"
  :long-description "cl-cffi-kit provides cleanup-safe foreign-memory and
foreign-string scopes, direct CFFI memory helpers, and a consistent condition
for checking foreign return codes. Every scope is a CALL-WITH-* function in
continuation-passing style; the WITH-* macros expand to calls to them. It is
a small portability layer for Common Lisp code that calls C libraries
through CFFI."
  :author "takeokunn <bararararatty@gmail.com>"
  :maintainer "takeokunn <bararararatty@gmail.com>"
  :license "MIT"
  :version "0.1.0"
  :homepage "https://github.com/nerima-lisp/cl-cffi-kit"
  :bug-tracker "https://github.com/nerima-lisp/cl-cffi-kit/issues"
  :source-control (:git "https://github.com/nerima-lisp/cl-cffi-kit.git")
  :depends-on ("cffi")
  :pathname "src"
  :serial t
  :components
  ((:file "package")
   (:file "conditions")
   (:file "version")
   (:file "memory")
   (:file "strings")
   (:file "errors"))
  :in-order-to ((test-op (test-op "cl-cffi-kit/test"))))

(defsystem "cl-cffi-kit/test"
  :description "Test system for cl-cffi-kit"
  :author "takeokunn <bararararatty@gmail.com>"
  :maintainer "takeokunn <bararararatty@gmail.com>"
  :license "MIT"
  :version "0.1.0"
  :homepage "https://github.com/nerima-lisp/cl-cffi-kit"
  :bug-tracker "https://github.com/nerima-lisp/cl-cffi-kit/issues"
  :source-control (:git "https://github.com/nerima-lisp/cl-cffi-kit.git")
  :depends-on ("cl-cffi-kit" "cl-weave")
  :pathname "t"
  :serial t
  :components
  ((:file "package")
   (:file "helpers-matchers")
   (:file "version-test")
   (:file "memory-test")
   (:file "strings-test")
   (:file "errors-test"))
  :perform (test-op (operation component)
             (declare (ignore operation component))
             (unless (funcall (symbol-function (find-symbol "RUN-TESTS" "CL-CFFI-KIT/TEST")))
               (error "cl-cffi-kit test suite failed"))))
