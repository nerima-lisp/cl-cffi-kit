;;;; t/errors-test.lisp
(in-package #:cl-cffi-kit/test)

(defun %check-foreign-error-defun-form ()
  "Return CHECK-FOREIGN-ERROR's DEFUN form, mirrored here so mutation testing
can redefine it without reading back the compiled function."
  '(defun check-foreign-error (function code &key (success 0))
     (if (eql code success)
         code
         (error 'foreign-call-error :function function :code code))))

(describe
  "cl-cffi-kit-error"
  (it "is a proper ERROR subtype"
    (expect (subtypep 'cl-cffi-kit-error 'error) :to-be-truthy))

  (it "foreign-call-error is a subtype of it"
    (expect (subtypep 'foreign-call-error 'cl-cffi-kit-error) :to-be-truthy))

  (it "reports itself with a generic message"
    (expect (handler-case (error 'cl-cffi-kit-error)
              (cl-cffi-kit-error (condition) (format nil "~A" condition)))
            :to-equal "A cl-cffi-kit error occurred."))

  (it "FOREIGN-CALL-ERROR reports the function and code it carries"
    (let ((report (handler-case (check-foreign-error 'my-fn 7)
                     (foreign-call-error (condition) (format nil "~A" condition)))))
      (expect (search "MY-FN" report) :to-satisfy #'integerp)
      (expect (search "7" report) :to-satisfy #'integerp))))

(describe
  "check-foreign-error"
  (it "returns the code unchanged when it matches the default success code"
    (expect (check-foreign-error 'success 0) :to-equal 0))

  (it-each ((0 0) (5 5) (-1 -1))
      "returns CODE unchanged when it matches an explicit :success ~A"
      (code success)
    (expect (check-foreign-error 'success code :success success) :to-equal code))

  (it "signals FOREIGN-CALL-ERROR carrying the function and code on mismatch"
    (expect (lambda () (check-foreign-error 'failure 1))
            :to-signal-foreign-call-error 'failure 1))

  (it-each ((1 0) (-1 0) (2 1))
      "signals FOREIGN-CALL-ERROR when CODE ~A does not match :success"
      (code success)
    (expect (lambda () (check-foreign-error 'failure code :success success))
            :to-signal-foreign-call-error 'failure code)))

(describe
  "with-checked-foreign-call"
  (it "returns the value when the call's own operator succeeds"
    (flet ((always-ok (x) (declare (ignore x)) 0))
      (expect (with-checked-foreign-call (always-ok 1)) :to-equal 0)))

  (it "signals FOREIGN-CALL-ERROR naming the call's own operator on failure"
    (flet ((always-fails (x) (declare (ignore x)) 1))
      (expect (lambda () (with-checked-foreign-call (always-fails 1)))
              :to-signal-foreign-call-error 'always-fails 1)))

  (it "honors an explicit :success"
    (flet ((always-two (x) (declare (ignore x)) 2))
      (expect (with-checked-foreign-call (always-two 1) :success 2) :to-equal 2))))

(describe
  "%expand-with-checked-foreign-call"
  (it "builds a CHECK-FOREIGN-ERROR call naming the call-form's own operator"
    (expect (cl-cffi-kit::%expand-with-checked-foreign-call '(some-c-function a b) 0)
            :to-equal '(check-foreign-error 'some-c-function (some-c-function a b) :success 0))))

(it-sequential "the success/failure branch in CHECK-FOREIGN-ERROR kills every mutation"
  (let ((original-form (%check-foreign-error-defun-form)))
    (unwind-protect
         (let ((results (run-mutations
                         original-form
                         (lambda (mutant-form mutation)
                           (declare (ignore mutation))
                           (eval mutant-form)
                           (handler-case
                               (and (eql (check-foreign-error 'success 0) 0)
                                    (handler-case
                                        (progn (check-foreign-error 'failure 1) nil)
                                      (foreign-call-error () t)))
                             (error () nil))))))
           (expect (plusp (length results)) :to-be-truthy)
           (assert-mutation-score results 1.0))
      (eval original-form))))
