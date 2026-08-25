;;;; t/core-test.lisp
(in-package #:cl-cffi-kit/test)

(describe
  "cl-cffi-kit"
  (it "reports its own version, matching the .asd :version"
    (expect (library-version) :to-equal "0.1.0"))

  (it "CL-CFFI-KIT-ERROR is a proper ERROR subtype"
    (expect (subtypep 'cl-cffi-kit-error 'error) :to-be-truthy))

  (it "round-trips a foreign string"
    (with-foreign-string (pointer "hello")
      (expect (foreign-string-to-lisp pointer) :to-equal "hello")))

  (it "allocates and releases a foreign object"
    (with-foreign-object (pointer :int)
      (setf (mem-ref pointer :int) 42)
      (expect (mem-ref pointer :int) :to-equal 42)))

  (it "checks foreign return codes"
    (expect (check-foreign-error 'success 0) :to-equal 0)
    (expect
      (handler-case
          (progn (check-foreign-error 'failure 1) nil)
        (foreign-call-error (condition)
          (and (eql (foreign-call-error-function condition) 'failure)
               (eql (foreign-call-error-code condition) 1))))
      :to-be-truthy)))
