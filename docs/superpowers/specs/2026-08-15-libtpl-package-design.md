# libtpl Package Support Design

## Goal

Add a reproducible Xmake package recipe named `libtpl` for upstream tpl
1.6.1, so consumers such as FreeSWITCH can discover `tpl.h`, link `-ltpl`,
and use the upstream `libtpl.pc` metadata.

## Scope

- Add only `packages/l/libtpl/xmake.lua` for the package implementation.
- Keep the existing untracked `test.sh` and `CODEX_HANDOFF_LIBTPL.md`
  unchanged.
- Commit the recipe separately from this design record, keeping each commit
  focused.

## Package recipe

- Use the package name `libtpl` and the upstream repository
  `https://github.com/troydhanson/tpl.git`.
- Register version `1.6.1` from the GitHub release archive with SHA-256
  `fe2a0b78b71c36f1fa4afc320bfae3ab0f4c5732c83b0355a461440019a9af65`.
- Depend on `autoconf`, `automake`, and `libtool`.
- Run upstream `./bootstrap` before invoking the repository's Autoconf
  installer because the release archive lacks a generated `configure` file.
- Pass the package shared-library setting through to Autoconf, while
  explicitly exposing the installed library as link name `tpl`.
- Ensure the install exposes `include/tpl.h`, the shared or static `tpl`
  library selected by the package configuration, and
  `lib/pkgconfig/libtpl.pc` with version `1.6.1`, `-ltpl`, and
  `-I${includedir}` metadata. Prefer the upstream install target; add only a
  focused recipe-side correction if the archive does not install the metadata.
- Test the package through `package:has_cfuncs("tpl_map", {includes =
  "tpl.h"})`, which verifies both header visibility and linkability.

## Verification

Use the unchanged `test.sh` entry point with isolated package/cache/temp
directories. Run the package test for native Linux in both static and shared
modes. Run the same package test for the AArch64 cross platform in both modes,
using the installed AArch64 cross compiler and SDK configuration. For shared
builds, inspect the package prefix for the shared object and run
`pkg-config` against the installed `lib/pkgconfig` directory to verify the
reported version, include flags, and `-ltpl` link flag.

The recipe is ready only when all four `test.sh` package invocations complete
successfully and the shared-package metadata checks pass for native and
AArch64 outputs.
