# cl-cffi-kit

Common Lisp toolkit for safer, more ergonomic foreign-function usage across
this org's C-binding repositories.

## Status

The package is implemented on top of CFFI and provides cleanup-safe foreign
memory/string scopes plus consistent foreign-call error handling. Every scope
is a `call-with-*` function in continuation-passing style; the `with-*`
macros are thin sugar over them. See the [API reference](reference/api.md),
[Conditions](reference/conditions.md), and [roadmap](project/roadmap.md) for
the current scope and future extensions.
