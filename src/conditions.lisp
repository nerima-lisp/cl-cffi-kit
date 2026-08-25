;;;; src/conditions.lisp
(in-package #:cl-cffi-kit)

(define-condition cl-cffi-kit-error (error) ()
  (:documentation "Base condition for every error this library signals."))

(define-condition foreign-call-error (cl-cffi-kit-error)
  ((function :initarg :function :reader foreign-call-error-function)
   (code :initarg :code :reader foreign-call-error-code))
  (:report (lambda (condition stream)
             (format stream "Foreign call ~S failed with error code ~S."
                     (foreign-call-error-function condition)
                     (foreign-call-error-code condition)))))
