# cl-cffi-kit

[![CI](https://github.com/nerima-lisp/cl-cffi-kit/actions/workflows/ci.yml/badge.svg?branch=main)](https://github.com/nerima-lisp/cl-cffi-kit/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Documentation](https://img.shields.io/badge/docs-MkDocs%20Material-0a7a5a)](https://nerima-lisp.github.io/cl-cffi-kit/)

Common Lisp toolkit for safer, more ergonomic foreign-function usage,
provided on top of the portable [CFFI](https://cffi.common-lisp.dev/)
library. It includes cleanup-safe allocation scopes and consistent foreign
call error handling. Every scope is a `call-with-*` function in
continuation-passing style; the `with-*` macros are thin sugar over them.

Full documentation is published at <https://nerima-lisp.github.io/cl-cffi-kit/>.
The source for that site lives in [docs/src/](docs/src/).

## Quick Start

```lisp
(asdf:load-system "cl-cffi-kit")

(cl-cffi-kit:library-version)
;; => "0.1.0"
```

## Install

```nix
# flake.nix
inputs.cl-cffi-kit = {
  url = "github:nerima-lisp/cl-cffi-kit/v0.1.0";
  inputs.nixpkgs.follows = "nixpkgs";
};
```

Note the pinned tag. Consumers inside this org must pin a release tag rather
than follow the default branch.

## Documentation

- [Getting started](https://nerima-lisp.github.io/cl-cffi-kit/getting-started/)
- [API reference](https://nerima-lisp.github.io/cl-cffi-kit/reference/api/)
- [Roadmap](https://nerima-lisp.github.io/cl-cffi-kit/project/roadmap/)

## Development

```sh
nix develop          # SBCL with CL_SOURCE_REGISTRY already set
nix run .#test       # run the test suite
nix flake check      # tests + formatting + docs, the same gate CI uses
nix fmt              # format Nix sources (treefmt)
```

Tests live in `t/` and run under [cl-weave](https://github.com/nerima-lisp/cl-weave),
the org's test framework.

## Contributing

See the org-wide [CONTRIBUTING](https://github.com/nerima-lisp/.github/blob/main/CONTRIBUTING.md)
guide and the [package standard](https://github.com/nerima-lisp/.github/blob/main/PACKAGE_STANDARD.md).

## Support

See [SUPPORT](https://github.com/nerima-lisp/.github/blob/main/SUPPORT.md).

## License

MIT. See [LICENSE](LICENSE).
