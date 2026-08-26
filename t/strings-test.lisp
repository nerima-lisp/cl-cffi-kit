;;;; t/strings-test.lisp
(in-package #:cl-cffi-kit/test)

(describe
  "with-foreign-string"
  (it "round-trips a foreign string"
    (with-foreign-string (pointer "hello")
      (expect (foreign-string-to-lisp pointer) :to-equal "hello"))))

(describe
  "call-with-foreign-string"
  (it "passes the pointer to THUNK and returns THUNK's value"
    (expect (call-with-foreign-string "hi" #'foreign-string-to-lisp) :to-equal "hi")))

(it-property "round-trips an arbitrary NUL-free foreign string"
    ((text (gen-string
            :min-length 0 :max-length 64
            :alphabet "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789 !@#$%^&*()-_=+")))
  (with-foreign-string (pointer text)
    (expect (foreign-string-to-lisp pointer) :to-equal text)))

(describe
  "call-with-foreign-string resource lifecycle"
  (let (alloc-spy free-spy)
    (around-each (next)
      (setf alloc-spy (spy-on 'foreign-string-alloc))
      (setf free-spy (spy-on 'foreign-string-free))
      (unwind-protect (funcall next)
        (mock-restore alloc-spy)
        (mock-restore free-spy)))

    (it "allocates once and frees once on a normal return"
      (call-with-foreign-string "hello" (lambda (pointer) (declare (ignore pointer)) nil))
      (expect (length (mock-calls alloc-spy)) :to-equal 1)
      (expect (length (mock-calls free-spy)) :to-equal 1))

    (it "still frees exactly once when THUNK signals an error, which propagates"
      (signals error
        (call-with-foreign-string
         "hello"
         (lambda (pointer) (declare (ignore pointer)) (error "boom"))))
      (expect (length (mock-calls free-spy)) :to-equal 1))))

(describe
  "%expand-with-foreign-string"
  (it "builds a CALL-WITH-FOREIGN-STRING form forwarding OPTIONS"
    (expect (cl-cffi-kit::%expand-with-foreign-string 'ptr "hi" '(:encoding :utf-8) '((foo ptr)))
            :to-equal '(call-with-foreign-string "hi" (lambda (ptr) (foo ptr)) :encoding :utf-8))))

(describe-concurrent
  "concurrent foreign-string scopes"
  (it-each (("alpha") ("beta") ("gamma") ("delta"))
      "keeps a concurrently allocated foreign string isolated to its own scope (~A)"
      (text)
    (with-foreign-string (pointer text)
      (expect (foreign-string-to-lisp pointer) :to-equal text))))
