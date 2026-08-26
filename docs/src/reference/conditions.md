# Conditions

Every condition below is a subtype of `cl-cffi-kit-error`. Catch that to
handle any failure from this library without naming each specific condition.

| Condition | Signaled when |
|---|---|
| `foreign-call-error` | `check-foreign-error` is given a return code that does not equal its `:success` argument (`0` by default). Readers: `foreign-call-error-function`, `foreign-call-error-code`. |

`foreign-call-error-function` returns the function designator passed as
`check-foreign-error`'s first argument, unchanged. `foreign-call-error-code`
returns the mismatched return code.
