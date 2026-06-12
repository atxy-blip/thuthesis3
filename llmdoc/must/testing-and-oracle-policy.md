# Testing and Oracle Policy

## Main Oracle

Use `../thuthesis2e` as the primary behavior oracle. Its value is the existing
l3build test suite and known-working legacy implementation.

Passing tests in `thuthesis3` should eventually mean two things:

- behavior matches the legacy oracle where compatibility is intended;
- behavior intentionally differs only where the new architecture documents a
  reason.

## Migration Test Flow

For a module migration:

1. Identify the matching behavior area and tests in `../thuthesis2e`.
2. If the legacy suite lacks coverage, add or fix tests in
   `../thuthesis2e/master` when possible.
3. Test the LaTeX3 idea in a focused `../thuthesis2e/refactor/*` branch if that
   gives faster equivalence feedback.
4. Copy or adapt the successful design into `thuthesis3`.
5. Port the relevant tests into this repository when the corresponding module
   exists.

## What l3build Proves

l3build `.tlg` equality is necessary but not sufficient:

- it catches log-level and macro-level regressions for covered scenarios;
- it may miss visual PDF differences, typography, and page geometry issues;
- cover pages, frontmatter, and bibliography behavior may need PDF or visual
  checks.

## Current Local Build Facts

`thuthesis3/build.lua` currently declares:

- module: `thuthesis3`;
- check engine: `xetex`;
- typesetting engine: `xelatex`;
- source directory: `source`;
- source file: `source/thuthesis3.dtx`;
- generated install files: `.cls`, `.def`, and `tsinghua-name-bachelor.pdf`.

The repository has a local `testfiles/` tree. Current focused coverage includes:

- top-level setup-key compatibility tests (`info-keys-compat.tex` and
  `info-anonymous-compat.tex`, with anonymous mode currently excluded in
  `build.lua`);
- biblatex hook-loading coverage under `testfiles/biblatex/`, selected by
  `testfiles/config-biblatex.lua` and run with Biber;
- imported title-page fixtures under `testfiles/01-title-page/`;
- `testfiles/config-title-page.lua`, which currently includes a small title-page
  smoke subset for bachelor, doctor, and master covers.

The title-page fixtures were imported from upstream ThuThesis and regenerated
for `thuthesis3` in May 2026. They provide local regression coverage, but the
legacy `../thuthesis2e` suite remains the compatibility oracle for behavior not
yet ported here.
