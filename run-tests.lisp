(require :asdf)
(format t "tests: bootstrap~%")

;; Keep REQUIRE separate so the SB-COVER package exists before the declaration
;; is read.
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
  ;; CL-WEAVE is available only after the test system has loaded.
  (setf (symbol-value (find-symbol "*DEFAULT-TIMEOUT-MS*" "CL-WEAVE")) 20000)
  (format t "tests: run~%")
  (unless (funcall (find-symbol "RUN-TESTS" "CL-CFFI-KIT/TEST"))
    (error "cl-cffi-kit test suite failed"))
  (format t "tests: complete~%")
  (uiop:quit 0))
