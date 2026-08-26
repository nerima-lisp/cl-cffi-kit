;;;; t/helpers-matchers.lisp
(in-package #:cl-cffi-kit/test)

(defmatcher :to-signal-foreign-call-error (actual expected)
  "Passes when calling the no-argument thunk ACTUAL signals a
FOREIGN-CALL-ERROR whose FUNCTION and CODE slots are EQL to the
(function code) list EXPECTED."
  (destructuring-bind (expected-function expected-code) expected
    (handler-case
        (progn (funcall actual)
               (values nil
                       (list :signalled nil)
                       (list :function expected-function :code expected-code)))
      (foreign-call-error (condition)
        (values (and (eql (foreign-call-error-function condition) expected-function)
                     (eql (foreign-call-error-code condition) expected-code))
                (list :function (foreign-call-error-function condition)
                      :code (foreign-call-error-code condition))
                (list :function expected-function :code expected-code))))))
