# Roadmap

This repository is provisioning only today: GitHub repo, Cachix cache, CI,
and this documentation site exist; no toolkit code does.

## The open question this starts from

The name suggests wrapping the third-party [`cffi`](https://common-lisp.net/project/cffi/)
library, but that is not settled. This org's two existing FFI-binding
repositories, `cl-glfw3-kit` and `cl-vulkan-kit`, both bind their C
libraries directly through SBCL's bundled `sb-alien` — precisely so
`DEPENDENCY_POLICY.md`'s external-dependency procedure never applies (see
each repo's `.asd` `:depends-on ()` and `src/library.lisp`/`src/foreign-library.lisp`
comments). Two real options follow from that precedent:

- **Wrap `sb-alien` only.** Stay dependency-free like the sibling repos,
  and give them (and any future C-binding repo) a shared layer of
  ergonomics on top of `sb-alien` — scope-bound foreign-memory helpers,
  struct/array marshaling, error-code-to-condition mapping, callback
  trampolines. SBCL-only is already the org standard, so this loses
  nothing sibling repos need.
- **Wrap the `cffi` library.** More portable in the abstract and closer to
  what the name implies, but requires satisfying
  `DEPENDENCY_POLICY.md`'s 4-condition external-dependency test explicitly
  in the PR body, and would leave this toolkit unusable by
  `cl-glfw3-kit`/`cl-vulkan-kit` unless they also took on that dependency
  — undoing the reason they chose `sb-alien` in the first place.

Whichever is chosen determines everything else below; this has not been
decided yet.

## What implementing the toolkit requires

- **Design surface.** Which primitives come first: a `with-foreign-object`-style
  scope macro for automatic cleanup, a struct-field accessor generator, an
  error-code-to-condition mapping helper, or a callback-trampoline
  registration helper. `cl-glfw3-kit`'s and `cl-vulkan-kit`'s existing
  hand-written code is the concrete source of what to extract and
  generalize.
- **A real test target.** Marshaling code needs to round-trip through an
  actual C function to mean anything; libc functions already present on
  every CI runner (`getpid`, `strlen`, and similar) are a network-free
  starting point that needs no nixpkgs package added.
- **Consumer migration, if adopted.** If `cl-glfw3-kit`/`cl-vulkan-kit`
  end up depending on this toolkit, that is a second PR against each of
  those repos, not something this repository can do unilaterally.

## Not yet decided

- `sb-alien`-only vs. `cffi`-backed (see above) — the load-bearing decision
  everything else follows from.
- Whether this repository ever gains its own foreign shared library to
  test against, or stays scoped to libc-only round-trips indefinitely.
