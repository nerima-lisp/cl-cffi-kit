;;;; src/package.lisp
(defpackage #:cl-cffi-kit
  (:use #:cl)
  (:import-from #:cffi
                #:foreign-alloc #:foreign-free #:foreign-slot-value
                #:foreign-string-alloc #:foreign-string-to-lisp
                #:foreign-string-free)
  (:export
   ;; Version
   #:library-version
   ;; Memory scopes
   #:call-with-foreign-object
   #:with-foreign-object
   #:call-with-foreign-objects
   #:with-foreign-objects
   #:foreign-alloc
   #:foreign-free
   #:foreign-slot-value
   ;; String scopes
   #:call-with-foreign-string
   #:with-foreign-string
   #:foreign-string-to-lisp
   #:foreign-string-free
   ;; Error checking and conditions
   #:cl-cffi-kit-error
   #:foreign-call-error
   #:foreign-call-error-function
   #:foreign-call-error-code
   #:check-foreign-error
   #:with-checked-foreign-call))

(in-package #:cl-cffi-kit)
