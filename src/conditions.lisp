;;;; src/conditions.lisp
(in-package #:cl-cffi-kit)

(define-condition cl-cffi-kit-error (error) ()
  (:report (lambda (condition stream)
             (declare (ignore condition))
             (format stream "A cl-cffi-kit error occurred.")))
  (:documentation "Base condition for every error this library signals."))

(define-condition foreign-call-error (cl-cffi-kit-error)
  ((function :initarg :function :reader foreign-call-error-function)
   (code :initarg :code :reader foreign-call-error-code))
  (:report (lambda (condition stream)
             (format stream "Foreign call ~S failed with error code ~S."
                     (foreign-call-error-function condition)
                     (foreign-call-error-code condition))))
  (:documentation "Signalled when a foreign call's return code does not
match the expected success value."))
