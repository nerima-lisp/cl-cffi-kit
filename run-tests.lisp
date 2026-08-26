;;;; run-tests.lisp
;;;;
;;;; Bootstrap script: register this checkout's and cl-weave's ASDF
;;;; definitions, enable SBCL coverage instrumentation for the system under
;;;; test, bound the per-test timeout, and run the test system without
;;;; scanning every inherited source registry tree.

(require :asdf)
(format t "tests: bootstrap~%")

;; Two separate top-level forms, not one PROGN: LOAD reads a whole form
;; before evaluating it, so a single PROGN would try to read the
;; SB-COVER:STORE-COVERAGE-DATA symbol before REQUIRE has created that
;; package.
#+sbcl (require :sb-cover)
#+sbcl (proclaim '(optimize sb-cover:store-coverage-data))

(defun script-directory ()
  (make-pathname :name nil
                 :type nil
                 :defaults (or *load-truename*
                               *compile-file-truename*
                               (error "Unable to determine the script location"))))

(let ((root (script-directory)))
  (format t "tests: system definition~%")
  (push root asdf:*central-registry*)
  (push (merge-pathnames #P"../cl-weave/" root) asdf:*central-registry*)
  (format t "tests: load~%")
  (asdf:load-system "cl-cffi-kit/test")
  ;; Bound here, not in T/PACKAGE.LISP: CL-WEAVE only exists in the image
  ;; once ASDF:LOAD-SYSTEM above has pulled it in as a dependency.
  (setf (symbol-value (find-symbol "*DEFAULT-TIMEOUT-MS*" "CL-WEAVE")) 20000)
  (format t "tests: run~%")
  (unless (funcall (find-symbol "RUN-TESTS" "CL-CFFI-KIT/TEST"))
    (error "cl-cffi-kit test suite failed"))
  (format t "tests: complete~%")
  (uiop:quit 0))
