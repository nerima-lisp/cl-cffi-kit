;;;; src/strings.lisp
(in-package #:cl-cffi-kit)

(defun call-with-foreign-string (string thunk &rest options)
  "Return THUNK's value, called with a nul-terminated foreign copy of
STRING that is freed whether THUNK returns or unwinds. OPTIONS is
forwarded to CFFI:FOREIGN-STRING-ALLOC."
  (let ((pointer (apply #'foreign-string-alloc string options)))
    (unwind-protect (funcall thunk pointer)
      (foreign-string-free pointer))))

(defun %expand-with-foreign-string (name string options body)
  "Return WITH-FOREIGN-STRING's expansion for the given syntax pieces. Kept
apart from the DEFMACRO body so this expansion logic runs as an ordinary,
individually testable and coverage-trackable function; SBCL's code-coverage
instrumentation cannot see inside a macro's own body, since that body runs
once at expansion time rather than as part of the instrumented program."
  `(call-with-foreign-string ,string (lambda (,name) ,@body) ,@options))

(defmacro with-foreign-string ((name string &rest options) &body body)
  "Return BODY's value, with NAME bound to a nul-terminated foreign copy of
STRING that is freed on every exit path, including a non-local one.

NAME is a binding form and is not evaluated; STRING and OPTIONS are
evaluated, and OPTIONS is forwarded verbatim to CALL-WITH-FOREIGN-STRING
(and, through it, to CFFI:FOREIGN-STRING-ALLOC). Pure sugar over
CALL-WITH-FOREIGN-STRING:

  (with-foreign-string (ptr \"hello\")
    ...)
  ;; => (call-with-foreign-string \"hello\" (lambda (ptr) ...))"
  (%expand-with-foreign-string name string options body))
