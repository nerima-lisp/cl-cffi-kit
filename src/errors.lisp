;;;; src/errors.lisp
(in-package #:cl-cffi-kit)

(defun check-foreign-error (function code &key (success 0))
  "Return CODE when it equals SUCCESS; otherwise signal FOREIGN-CALL-ERROR."
  (if (eql code success)
      code
      (error 'foreign-call-error :function function :code code)))

(defun %expand-with-checked-foreign-call (call-form success)
  "Return WITH-CHECKED-FOREIGN-CALL's expansion for the given syntax
pieces. Kept apart from the DEFMACRO body so this expansion logic runs as
an ordinary, individually testable and coverage-trackable function; SBCL's
code-coverage instrumentation cannot see inside a macro's own body, since
that body runs once at expansion time rather than as part of the
instrumented program."
  `(check-foreign-error ',(first call-form) ,call-form :success ,success))

(defmacro with-checked-foreign-call (call-form &key (success 0))
  "Evaluate CALL-FORM and return its value via CHECK-FOREIGN-ERROR, using
CALL-FORM's own operator as the signalled condition's FUNCTION designator
so the caller never has to repeat it. CALL-FORM is evaluated exactly once;
SUCCESS is evaluated once.

  (with-checked-foreign-call (some-c-function arg1 arg2))
  ;; => (check-foreign-error 'some-c-function (some-c-function arg1 arg2)
  ;;                          :success 0)"
  (%expand-with-checked-foreign-call call-form success))
