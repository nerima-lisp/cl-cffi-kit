# API reference

## `library-version`

```lisp
(library-version)
```

Return this system's version string, kept in sync with `cl-cffi-kit.asd`'s
`:version`.

## Memory helpers

`with-foreign-object`, `with-foreign-objects`, and `with-foreign-string`
provide cleanup-safe scopes around the corresponding CFFI allocations.
`foreign-alloc`, `foreign-free`, `foreign-slot-value`, and
`foreign-string-to-lisp` are re-exported for direct use.

## Error checking

```lisp
(check-foreign-error 'some-c-function return-code)
```

Returns the success code (zero by default), or signals `foreign-call-error`
with the function designator and returned code.
