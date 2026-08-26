;;;; t/memory-test.lisp
(in-package #:cl-cffi-kit/test)

(describe
  "with-foreign-object"
  (it "allocates and releases a foreign object"
    (with-foreign-object (pointer :int)
      (setf (mem-ref pointer :int) 42)
      (expect (mem-ref pointer :int) :to-equal 42)))

  (it "returns BODY's value"
    (expect (with-foreign-object (pointer :int)
              (setf (mem-ref pointer :int) 0)
              :done)
            :to-equal :done)))

(describe
  "call-with-foreign-object"
  (it "passes the pointer to THUNK and returns THUNK's value"
    (expect (call-with-foreign-object :int 1
                                       (lambda (pointer)
                                         (setf (mem-ref pointer :int) 7)
                                         (mem-ref pointer :int)))
            :to-equal 7))

  (it-each ((1) (4) (10))
      "allocates a run-time-determined COUNT of ~A elements"
      (count)
    (call-with-foreign-object
     :int count
     (lambda (pointer)
       (dotimes (index count)
         (setf (mem-ref pointer :int index) index))
       (expect (mem-ref pointer :int (1- count)) :to-equal (1- count))))))

(describe
  "with-foreign-objects"
  (it "binds every element and releases all of them"
    (with-foreign-objects ((a :int) (b :double 2))
      (setf (mem-ref a :int) 1)
      (setf (mem-ref b :double 0) 2.5d0)
      (expect (mem-ref a :int) :to-equal 1)
      (expect (mem-ref b :double 0) :to-equal 2.5d0))))

(describe
  "call-with-foreign-objects"
  (it "allocates one pointer per binding, in order, for a run-time-determined list"
    (call-with-foreign-objects
     (list (list :int 1) (list :int 1) (list :int 1))
     (lambda (a b c)
       (setf (mem-ref a :int) 1 (mem-ref b :int) 2 (mem-ref c :int) 3)
       (expect (list (mem-ref a :int) (mem-ref b :int) (mem-ref c :int))
               :to-equal '(1 2 3)))))

  (it "returns THUNK's value for an empty binding list"
    (expect (call-with-foreign-objects '() (lambda () :ok)) :to-equal :ok))

  (it "defaults an omitted COUNT to 1, like WITH-FOREIGN-OBJECTS does"
    (call-with-foreign-objects
     (list (list :int))
     (lambda (pointer)
       (setf (mem-ref pointer :int) 9)
       (expect (mem-ref pointer :int) :to-equal 9)))))

(describe
  "%expand-with-foreign-object"
  (it "builds a CALL-WITH-FOREIGN-OBJECT form around a lambda binding NAME"
    (expect (cl-cffi-kit::%expand-with-foreign-object 'ptr :int 4 '((foo ptr)))
            :to-equal '(call-with-foreign-object :int 4 (lambda (ptr) (foo ptr))))))

(describe
  "%expand-with-foreign-objects"
  (it "builds a CALL-WITH-FOREIGN-OBJECTS form binding every NAME positionally"
    (expect (cl-cffi-kit::%expand-with-foreign-objects
             '((a :int) (b :double 2)) '((foo a b)))
            :to-equal '(call-with-foreign-objects
                        (list (list :int 1) (list :double 2))
                        (lambda (a b) (foo a b))))))

(describe-concurrent
  "concurrent foreign-object scopes"
  (it-each ((101) (202) (303) (404) (505))
      "keeps a concurrently allocated foreign int isolated to its own scope (~A)"
      (value)
    (with-foreign-object (pointer :int)
      (setf (mem-ref pointer :int) value)
      (expect (mem-ref pointer :int) :to-equal value))))
