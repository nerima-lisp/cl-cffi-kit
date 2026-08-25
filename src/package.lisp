;;;; src/package.lisp
(defpackage #:cl-cffi-kit
  (:use #:cl)
  (:import-from #:cffi
                #:foreign-alloc #:foreign-free #:foreign-slot-value
                #:foreign-string-alloc #:foreign-string-to-lisp
                #:foreign-string-free)
  (:export
   #:library-version
   #:cl-cffi-kit-error
   #:foreign-alloc
   #:foreign-free
   #:foreign-slot-value
   #:with-foreign-object
   #:with-foreign-objects
   #:with-foreign-string
   #:foreign-string-to-lisp
   #:foreign-string-free
   #:foreign-call-error
   #:foreign-call-error-function
   #:foreign-call-error-code
   #:check-foreign-error))

(in-package #:cl-cffi-kit)
