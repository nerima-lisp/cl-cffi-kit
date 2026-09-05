# Roadmap

The initial CFFI toolkit is implemented. It currently focuses on small,
portable primitives useful across foreign-function bindings.

## Current scope

- `call-with-foreign-object`/`call-with-foreign-objects`/`call-with-foreign-string`,
  each in continuation-passing style; the `with-*` macros expand to calls to
  them
- Re-exported CFFI allocation, freeing, slot, and string operations
- `check-foreign-error`, `with-checked-foreign-call`, and `foreign-call-error`
- Nix/ASDF integration, executable tests, mutation testing, property-based
  testing, and coverage-gated CI

## Possible extensions

Future additions may include higher-level struct/array marshaling helpers,
error-code mapping registries, and callback-trampoline utilities. These should
be added when a concrete consumer requires them and their behavior can be
covered by tests against a real foreign function.
