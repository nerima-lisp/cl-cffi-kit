;;;; cl-cffi-kit.asd
(in-package #:asdf-user)

(defsystem "cl-cffi-kit"
  :description "Common Lisp toolkit for safer, more ergonomic CFFI foreign-function usage"
  :long-description "cl-cffi-kit will provide a shared toolkit for the
foreign-function code that binds C libraries across this org (scope-bound
foreign-memory helpers, struct/array marshaling, error-code-to-condition
mapping, callback trampolines). No such toolkit is implemented yet -- this
repository is provisioning only. See docs/src/project/roadmap.md, in
particular the open question of whether this wraps the third-party `cffi`
library at all: cl-glfw3-kit and cl-vulkan-kit, this org's two existing
FFI-binding repositories, both bind their C libraries directly through
SBCL's bundled SB-ALIEN specifically to avoid DEPENDENCY_POLICY.md's
external-dependency procedure (cffi is precedented only in cl-tmux, an L4
repository, today). Any PR that adds a real cffi :depends-on here must
satisfy that procedure's 4-condition test explicitly."
  :author "takeokunn <bararararatty@gmail.com>"
  :maintainer "takeokunn <bararararatty@gmail.com>"
  :license "MIT"
  :version "0.1.0"
  :homepage "https://github.com/nerima-lisp/cl-cffi-kit"
  :bug-tracker "https://github.com/nerima-lisp/cl-cffi-kit/issues"
  :source-control (:git "https://github.com/nerima-lisp/cl-cffi-kit.git")
  :depends-on ()
  :pathname "src"
  :serial t
  :components
  ((:file "package")
   (:file "conditions")
   (:file "core"))
  :in-order-to ((test-op (test-op "cl-cffi-kit/test"))))

(defsystem "cl-cffi-kit/test"
  :description "Test system for cl-cffi-kit"
  :author "takeokunn <bararararatty@gmail.com>"
  :maintainer "takeokunn <bararararatty@gmail.com>"
  :license "MIT"
  :version "0.1.0"
  :homepage "https://github.com/nerima-lisp/cl-cffi-kit"
  :bug-tracker "https://github.com/nerima-lisp/cl-cffi-kit/issues"
  :source-control (:git "https://github.com/nerima-lisp/cl-cffi-kit.git")
  :depends-on ("cl-cffi-kit" "cl-weave")
  :pathname "t"
  :serial t
  :components
  ((:file "package")
   (:file "core-test"))
  :perform (test-op (operation component)
             (declare (ignore operation component))
             (unless (funcall (symbol-function (find-symbol "RUN-TESTS" "CL-CFFI-KIT/TEST")))
               (error "cl-cffi-kit test suite failed"))))
