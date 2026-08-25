;;;; src/core.lisp
(in-package #:cl-cffi-kit)

(defparameter +version+ "0.1.0"
  "Kept in sync with cl-cffi-kit.asd's :version by hand; see release.yml,
which refuses to publish a tag that disagrees with the .asd.")

(defun library-version ()
  "Return this system's version string."
  +version+)

(defmacro with-foreign-object ((name type &optional (count 1)) &body body)
  "Allocate a CFFI object for BODY and release it on every exit path."
  `(cffi:with-foreign-object (,name ,type ,count)
     ,@body))

(defmacro with-foreign-objects (bindings &body body)
  "Allocate several CFFI objects for BODY and release them on every exit path."
  `(cffi:with-foreign-objects ,bindings
     ,@body))

(defmacro with-foreign-string ((name string &rest options) &body body)
  "Allocate a nul-terminated foreign string for BODY and release it afterward."
  `(cffi:with-foreign-string (,name ,string ,@options)
     ,@body))

(defun check-foreign-error (function code &key (success 0))
  "Return CODE when it equals SUCCESS; otherwise signal FOREIGN-CALL-ERROR."
  (if (eql code success)
      code
      (error 'foreign-call-error :function function :code code)))
