;;;; src/conditions.lisp
(in-package #:cl-cffi-kit)

(define-condition cl-cffi-kit-error (error) ()
  (:documentation "Base condition for every error this library signals."))
