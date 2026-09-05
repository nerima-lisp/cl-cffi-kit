(in-package #:cl-cffi-kit)

(defun call-with-foreign-object (type count thunk)
  "Return THUNK's value, called with a foreign object of TYPE (COUNT
elements) that is freed whether THUNK returns or unwinds.

Delegates to CFFI:WITH-FOREIGN-OBJECT, so any allocation optimization CFFI
applies for a compile-time-constant TYPE/COUNT at THUNK's own call site
still applies wherever WITH-FOREIGN-OBJECT expands directly to it."
  (cffi:with-foreign-object (pointer type count)
    (funcall thunk pointer)))

(defun %expand-with-foreign-object (name type count body)
  "Return WITH-FOREIGN-OBJECT's expansion for the given syntax pieces."
  `(call-with-foreign-object ,type ,count (lambda (,name) ,@body)))

(defmacro with-foreign-object ((name type &optional (count 1)) &body body)
  "Return BODY's value, with NAME bound to a foreign object of TYPE (COUNT
elements) that is freed on every exit path, including a non-local one.

NAME is a binding form and is not evaluated; TYPE and COUNT are evaluated.
Expands to CALL-WITH-FOREIGN-OBJECT:

  (with-foreign-object (ptr :int 4)
    ...)
  ;; => (call-with-foreign-object :int 4 (lambda (ptr) ...))"
  (%expand-with-foreign-object name type count body))

(defun call-with-foreign-objects (bindings thunk)
  "Return THUNK's value, called with one freshly allocated foreign pointer
per element of BINDINGS, in order. Each element of BINDINGS is a
(TYPE &optional COUNT) list. Every allocation is freed, in reverse order,
whether THUNK returns or unwinds.

THUNK is called with as many positional arguments as BINDINGS has elements,
so a caller whose binding count is only known at run time can still use
this without macro-expansion-time knowledge of how many pointers there are."
  (labels ((recurse (remaining pointers)
             (if (null remaining)
                 (apply thunk (nreverse pointers))
                 (destructuring-bind (type &optional (count 1)) (first remaining)
                   (call-with-foreign-object
                    type count
                    (lambda (pointer) (recurse (rest remaining) (cons pointer pointers))))))))
    (recurse bindings '())))

(defun %expand-with-foreign-objects (bindings body)
  "Return WITH-FOREIGN-OBJECTS's expansion for the given syntax pieces."
  `(call-with-foreign-objects
    (list ,@(mapcar (lambda (binding)
                       (destructuring-bind (name type &optional (count 1)) binding
                         (declare (ignore name))
                         `(list ,type ,count)))
                     bindings))
    (lambda ,(mapcar #'first bindings) ,@body)))

(defmacro with-foreign-objects (bindings &body body)
  "Return BODY's value, with each of BINDINGS bound to a freshly allocated
foreign object that is freed on every exit path, including a non-local one.

BINDINGS is a list of (NAME TYPE &optional COUNT) forms; each NAME is a
binding form and is not evaluated, while TYPE and COUNT are evaluated. It
expands to CALL-WITH-FOREIGN-OBJECTS:

  (with-foreign-objects ((a :int) (b :double 2))
    ...)
  ;; => (call-with-foreign-objects (list (list :int 1) (list :double 2))
  ;;                                (lambda (a b) ...))"
  (%expand-with-foreign-objects bindings body))
