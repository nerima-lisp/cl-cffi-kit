# Roadmap

The initial CFFI toolkit is implemented. It currently focuses on small,
portable primitives useful across foreign-function bindings.

## Current scope

- `with-foreign-object`, `with-foreign-objects`, and `with-foreign-string`
- Re-exported CFFI allocation, freeing, slot, and string operations
- `check-foreign-error` and `foreign-call-error`
- Nix/ASDF integration and executable tests

## Possible extensions

Future additions may include higher-level struct/array marshaling helpers,
error-code mapping registries, and callback-trampoline utilities. These should
be added when a concrete consumer requires them and their behavior can be
covered by tests against a real foreign function.
