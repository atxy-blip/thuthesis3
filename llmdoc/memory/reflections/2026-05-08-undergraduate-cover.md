# 2026-05-08 Undergraduate Cover Layout Update

## Task

Update the undergraduate Chinese cover (`cover-u`) layout to match the current
oracle behavior, including dynamic secret rendering, new two-file logo system,
revised typography, and shared supervisor formatting helpers.

## Summary

The undergraduate cover elements (`secret`, `name-img`, `thesis`, `title`,
`date`) and page geometry were revised with explicit measurements. The
supervisor name/title formatting helpers (`\@@_cover_format_name:n`,
`\@@_cover_format_title:n`, `\@@_cover_format_supv:NNNn`) were promoted from
graduate-only (`\@@_g_cover_format_*`) to shared class-level (`\@@_cover_format_*`).
The date format for undergraduate switched from year-month-day to year-month,
matching the graduate format. The `\@@_zhdigits:nn` helper was simplified and
moved from `def-g|def-p` to `class` scope.

## What Went Well

- Promoting supervisor formatting to class-level correctly recognizes that the
  `3cm` pad + `4em`/`3em` stretch pattern is shared across degree types, not
  graduate-specific.
- Dynamic secret rendering (`\g_@@_info_secretlv_tl` + `\g_@@_info_secretyr_tl`)
  replaces the hardcoded `机密10年` string, making `cover-u/secret` consistent
  with `cover-g-zh/secret`.
- The two-logo system (figure logo + text logo) with explicit `50.4bp`/`117bp`
  widths, `10bp` spacing, and `7bp` raise matches the current university
  branding and is more maintainable than the old single-file approach.
- Page geometry uses explicit `top`/`bottom`/`left`/`right` measurements
  rather than generic `vmargin`/`hmargin`, making the layout contract
  verifiable against the oracle.
- Build system (`build.lua`) cleanly tracks the logo file list as a single
  table, avoiding scattered file references.

## What Went Wrong

- The logo file replacement (`tsinghua-name-bachelor.pdf` → `thu-fig-logo.pdf`
  + `thu-text-logo.pdf`) and the cover formatting changes are in the same
  uncommitted diff. These are separable concerns: the layout metrics and the
  logo file switch could be two commits.
- `\@@_include_graphics:nn` wraps `\includegraphics` in a one-line helper.
  This is a thin wrapper that adds a layer of indirection for the sole purpose
  of getting a `:nV` variant. Whether this is worth the indirection should be
  weighed against just using `\exp_args:NV \includegraphics` at the call site.

## Root Cause

The undergraduate cover had placeholder values (hardcoded secret text, old
logo reference, approximate skip values) from the initial skeleton. This
update brings them into alignment with the oracle measurements.

## Missing Docs or Signals

| # | Gap | Where it should go |
|---|-----|-------------------|
| 1 | `\@@_cover_format_name:n`/`\@@_cover_format_title:n` and their variants are now shared helpers but undocumented outside the code | `reference/cover-structure-and-todo.md` |
| 2 | `\@@_include_graphics:nn` and its `nV` variant are undocumented | `reference/cover-structure-and-todo.md` |
| 3 | The two-logo layout parameters (widths, spacing, raise) are only in the code | `reference/cover-structure-and-todo.md` |
| 4 | Undergraduate date format change (ymd→ym) is undocumented | `reference/cover-structure-and-todo.md` |

## Promotion Candidates

- **`reference/cover-structure-and-todo.md`**: Update TODO items for
  undergraduate cover parity (dynamic secret, logo, title, date), document
  shared supervisor formatting helpers, mark completed items.
- **Memory only** (do not promote): The decision to use a thin
  `\@@_include_graphics:nn` wrapper for `nV` variant access is a local
  implementation choice; future tasks can inline it if the indirection proves
  unnecessary.

## Follow-up

Update `cover-structure-and-todo.md` to reflect the new undergraduate cover
state and mark relevant TODO items as done.
