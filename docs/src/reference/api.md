# API reference

Every scope in this library is a `call-with-*` function in continuation-passing
style. The matching `with-*` macro expands to a call to it; see each macro's
expansion example below.

## Version

### `library-version`

```lisp
(cl-cffi-kit:library-version)
  => string
```

Return this system's version string, kept in sync with `cl-cffi-kit.asd`'s
`:version`.

**Returns**: the version string, e.g. `"0.1.0"`.

**Signals**: none

**Example**:

```lisp
(cl-cffi-kit:library-version)
; => "0.1.0"
```

## Memory scopes

### `call-with-foreign-object`

```lisp
(cl-cffi-kit:call-with-foreign-object type count thunk)
  => thunk's value
```

Call `thunk` with a foreign pointer to a freshly allocated object of `type`
(`count` elements), freeing it whether `thunk` returns or unwinds. Delegates
to `cffi:with-foreign-object`.

**Returns**: `thunk`'s value.

**Signals**: none

**Example**:

```lisp
(cl-cffi-kit:call-with-foreign-object
 :int 1
 (lambda (pointer) (setf (cffi:mem-ref pointer :int) 42) (cffi:mem-ref pointer :int)))
; => 42
```

See also: [`with-foreign-object`](#with-foreign-object)

### `with-foreign-object`

```lisp
(cl-cffi-kit:with-foreign-object (name type &optional count) &body body)
  => body's value
```

Bind `name` to a foreign object of `type` (`count` elements, default 1) for
the extent of `body`, freeing it on every exit path. It expands to
`call-with-foreign-object`.

**Returns**: `body`'s value.

**Signals**: none

**Example**:

```lisp
(cl-cffi-kit:with-foreign-object (ptr :int)
  (setf (cffi:mem-ref ptr :int) 42)
  (cffi:mem-ref ptr :int))
; => 42
;; Expands to:
;; (cl-cffi-kit:call-with-foreign-object :int 1 (lambda (ptr) ...))
```

### `call-with-foreign-objects`

```lisp
(cl-cffi-kit:call-with-foreign-objects bindings thunk)
  => thunk's value
```

Call `thunk` with one freshly allocated foreign pointer per element of
`bindings`, in order, freeing every allocation (in reverse order) whether
`thunk` returns or unwinds. Each element of `bindings` is a
`(type &optional count)` list; `thunk` is called with as many positional
arguments as `bindings` has elements. Unlike `with-foreign-objects`, the
number of bindings can be a run-time value.

**Returns**: `thunk`'s value.

**Signals**: none

**Example**:

```lisp
(cl-cffi-kit:call-with-foreign-objects
 (list (list :int) (list :double 2))
 (lambda (a b) (cffi:mem-ref a :int)))
; => 0
```

See also: [`with-foreign-objects`](#with-foreign-objects)

### `with-foreign-objects`

```lisp
(cl-cffi-kit:with-foreign-objects (bindings) &body body)
  => body's value
```

Bind each `(name type &optional count)` form in `bindings` to a freshly
allocated foreign object for the extent of `body`, freeing all of them on
every exit path. It expands to `call-with-foreign-objects`.

**Returns**: `body`'s value.

**Signals**: none

**Example**:

```lisp
(cl-cffi-kit:with-foreign-objects ((a :int) (b :double 2))
  (cffi:mem-ref a :int))
; => 0
;; Expands to:
;; (cl-cffi-kit:call-with-foreign-objects
;;  (list (list :int 1) (list :double 2)) (lambda (a b) ...))
```

### `foreign-alloc`

Re-exported from CFFI unchanged. See [CFFI's `foreign-alloc`
documentation](https://cffi.common-lisp.dev/manual/cffi-manual.html#Allocating-Foreign-Memory).

### `foreign-free`

Re-exported from CFFI unchanged; releases memory obtained from
`foreign-alloc`. See [CFFI's `foreign-free`
documentation](https://cffi.common-lisp.dev/manual/cffi-manual.html#Allocating-Foreign-Memory).

### `foreign-slot-value`

Re-exported from CFFI unchanged; accesses a slot of a foreign struct or
union. See [CFFI's `foreign-slot-value`
documentation](https://cffi.common-lisp.dev/manual/cffi-manual.html#Accessing-Foreign-Structures).

## String scopes

### `call-with-foreign-string`

```lisp
(cl-cffi-kit:call-with-foreign-string string thunk &rest options)
  => thunk's value
```

Call `thunk` with a nul-terminated foreign copy of `string`, freeing it
whether `thunk` returns or unwinds. `options` is forwarded to
`cffi:foreign-string-alloc`.

**Returns**: `thunk`'s value.

**Signals**: none

**Example**:

```lisp
(cl-cffi-kit:call-with-foreign-string "hi" #'cl-cffi-kit:foreign-string-to-lisp)
; => "hi"
```

See also: [`with-foreign-string`](#with-foreign-string)

### `with-foreign-string`

```lisp
(cl-cffi-kit:with-foreign-string (name string &rest options) &body body)
  => body's value
```

Bind `name` to a nul-terminated foreign copy of `string` for the extent of
`body`, freeing it on every exit path. `options` is forwarded verbatim to
`call-with-foreign-string`. It expands to `call-with-foreign-string`.

**Returns**: `body`'s value.

**Signals**: none

**Example**:

```lisp
(cl-cffi-kit:with-foreign-string (ptr "hello")
  (cl-cffi-kit:foreign-string-to-lisp ptr))
; => "hello"
;; Expands to:
;; (cl-cffi-kit:call-with-foreign-string "hello" (lambda (ptr) ...))
```

### `foreign-string-to-lisp`

Re-exported from CFFI unchanged; decodes a foreign C string into a Lisp
string. See [CFFI's `foreign-string-to-lisp`
documentation](https://cffi.common-lisp.dev/manual/cffi-manual.html#Foreign-Strings).

### `foreign-string-free`

Re-exported from CFFI unchanged; releases memory obtained from
`foreign-string-alloc`. See [CFFI's `foreign-string-free`
documentation](https://cffi.common-lisp.dev/manual/cffi-manual.html#Foreign-Strings).

## Error checking and conditions

### `check-foreign-error`

```lisp
(cl-cffi-kit:check-foreign-error function code &key (success 0))
  => code
```

Return `code` when it is `eql` to `success`; otherwise signal
`foreign-call-error` naming `function` and carrying `code`.

**Returns**: `code`, unchanged, when it equals `success`.

**Signals**: `foreign-call-error` (when `code` does not equal `success`; see
[Conditions](conditions.md))

**Example**:

```lisp
(cl-cffi-kit:check-foreign-error 'some-c-function 0)
; => 0
```

See also: [`with-checked-foreign-call`](#with-checked-foreign-call), [Conditions](conditions.md)

### `with-checked-foreign-call`

```lisp
(cl-cffi-kit:with-checked-foreign-call call-form &key (success 0))
  => call-form's value
```

Evaluate `call-form` and check its value with `check-foreign-error`, using
`call-form`'s own operator as the signalled condition's function designator
— the caller never repeats the function name. `call-form` is evaluated
exactly once; `success` is evaluated once.

**Returns**: `call-form`'s value, unchanged, when it equals `success`.

**Signals**: `foreign-call-error` (when `call-form`'s value does not equal
`success`; see [Conditions](conditions.md))

**Example**:

```lisp
(cl-cffi-kit:with-checked-foreign-call (some-c-function arg1 arg2))
; => (cl-cffi-kit:check-foreign-error 'some-c-function (some-c-function arg1 arg2)
;                                      :success 0)
```

See also: [`check-foreign-error`](#check-foreign-error), [Conditions](conditions.md)
