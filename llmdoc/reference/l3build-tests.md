# l3build Tests

Use this reference when changing `build.lua`, adding `testfiles/` fixtures, or
regenerating `.tlg` files.

## Current Layout

- `testfiles/info-keys-compat.tex`: compatibility coverage for canonical
  grouped `\thusetup[info]{...}` keys and inherited unprefixed aliases.
- `testfiles/info-anonymous-compat.tex`: anonymous-mode filtering coverage. It
  currently exists with a saved `.tlg`, but `build.lua` excludes it from the
  default check run.
- `testfiles/01-title-page/`: 29 title-page fixtures imported from upstream
  ThuThesis and regenerated for `thuthesis3`. Their cover-category and input
  matrix is documented in `llmdoc/reference/cover-structure-and-todo.md`.
  These fixtures call concrete `xtemplate` cover instances directly; legacy
  command compatibility needs separate tests.
- `testfiles/config-title-page.lua`: focused title-page config. It currently
  includes a smoke subset rather than every imported title-page fixture.

## Build Configuration

`build.lua` currently checks with `xetex` and runs these configs:

- `build`;
- `testfiles/config-title-page`.

Several additional title-page-adjacent configs are present as comments in
`build.lua`. Treat them as future expansion notes, not active test coverage.

## Saving Tests

For ordinary focused changes, use normal l3build commands for the relevant test
or config. The repository also provides a custom `save-all` target that walks
the configured test configs and saves the tests discovered in each one.

During the current cover-layout migration phase, do not use `l3build check` as
the main feedback loop for title-page work. The cover implementation, hook flow,
and fixture surfaces are all still moving, so `.tlg` differences mostly record
internal churn rather than the behavior being tuned. For cover pages, compare
PDF output visually and numerically first; only return to `l3build check` and
`.tlg` saving after the relevant cover family is considered structurally stable.

When hook or phase refactors only reorder internal execution, `.tlg` output can
change even when PDFs are identical. For cover-page changes, verify visual
equivalence before accepting regenerated `.tlg` files; see
`llmdoc/reference/latexpagediff-verification.md`.
