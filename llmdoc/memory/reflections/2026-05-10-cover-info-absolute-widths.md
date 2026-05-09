# 2026-05-10 Undergraduate Cover Info Absolute Widths

## Task

Reflect on the undergraduate cover info alignment fix after separating
`\l_@@_coverlabel_dim` / `\l_@@_covertext_dim` setup into definition-file
constants.

## Summary

The undergraduate info label alignment issue was caused by freezing an `em`
dimension outside the active cover font context. In the oracle, the label text
widths are `4em` and `5em` while the info block is set at `16bp`, so the
equivalent absolute widths are `64bp` and `80bp`.

The current implementation keeps separated width constants:

- `source/thuthesis3.dtx` (`c label wd`, `c label wd a`): undergraduate label
  box widths are `2.5cm` and `86bp`.
- `source/thuthesis3.dtx` (`c text wd`, `c text wd a`): undergraduate label
  text widths are `64bp` and `80bp`, converted from oracle `4em` and `5em`
  under the `16bp` info font.
- `source/thuthesis3.dtx` (`\@@_cover_info_dims:NNNN`): copies those constants
  into `\l_@@_coverlabel_dim` / `\l_@@_covertext_dim`.

Keeping these values absolute is acceptable here because the undergraduate
cover info font is explicitly fixed by `u / cover / info` to `16bp`.

## What Went Well

- The separated constants make the undergraduate and graduate geometry
  greppable and keep family differences out of the row-drawing code.
- Converting `4em` / `5em` to `64bp` / `80bp` preserves the oracle geometry
  while avoiding an `em` value being evaluated too early.
- Bbox comparison was the right diagnostic: the label box width was correct,
  but the inner label text width was too small.

## What Went Wrong

- Treating `em` as a safe constant was incorrect. In TeX, `em` depends on the
  current font at assignment time, so moving an `em` dimension into a constant
  table can silently change layout.
- The line-end `\skip_horizontal:n { 6pt }` was suspected as part of the fix,
  but user testing showed it is visually useless for this alignment issue.
  Do not reintroduce it as a compensation unless a separate box-width test
  proves that the table object's natural width matters.

## Root Cause

The refactor changed when the label text width was evaluated. The oracle
evaluates `4em` / `5em` inside the undergraduate info block's `16bp` font. The
constant-table version evaluated `em` before that font was active, producing
the wrong label text distribution even though the outer label width was
correct.

## Missing Docs or Signals

| # | Gap | Where it should go |
|---|-----|-------------------|
| 1 | `cover-structure-and-todo.md` still describes undergraduate text widths as `4em` / `5em`; it should mention the implementation uses `64bp` / `80bp` because the info font is fixed at `16bp` | `reference/cover-structure-and-todo.md` |
| 2 | The rule "do not freeze font-relative units in constants unless converted under a fixed font contract" is not documented | `reference/cover-structure-and-todo.md` or a future coding-conventions reference |

## Promotion Candidates

- `reference/cover-structure-and-todo.md`: update the unified cover info
  system section so undergraduate text widths are recorded as `64bp` / `80bp`
  in implementation, equivalent to oracle `4em` / `5em` under the fixed
  `16bp` info font.
- Memory only: the failed `6pt` row-end padding hypothesis.
