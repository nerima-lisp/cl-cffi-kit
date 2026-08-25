# Getting started

## Install

Via a sibling checkout on `CL_SOURCE_REGISTRY` or ASDF's `*central-registry*`:

```lisp
(asdf:load-system "cl-cffi-kit")
```

## Running the tests

```sh
sbcl --script run-tests.lisp
```

expects a sibling `../cl-weave/` checkout (the test system's only
dependency; see `cl-cffi-kit.asd`).

The package depends on [CFFI](https://cffi.common-lisp.dev/) and provides
cleanup-safe allocation scopes plus common error-code handling. See the
[API reference](reference/api.md).
