# 2026-05-09 Undergraduate Cover Spacing Refinement

## Task

Adjust the undergraduate cover (`cover-u`) element spacing to match
`thuthesis2e` visual output. The secret, thulogo, thesis-label, and title
elements were refined for overlay parity. The info element spacing was
intentionally kept as a fill-based interim and will be addressed separately.

## Summary

A new `top-anchor` page-template key (`null` / `none`, default `null`)
replaces the unconditional `\hbox:n{}` that started every page instance.
Undergraduate covers set `top-anchor = none` because their layout starts
directly from the first element box, unlike graduate covers that need
`\null\vskip` reproduction. The `u/cover/name-img` element was renamed to
`u/cover/thulogo` and its inline content extracted into `\@@_u_cover_thulogo:`.
The title element was rewritten as `\@@_u_cover_title:` using
`\@@_box_paragraph_top_to_ht:nn` with `\prevdepth` preservation and
`\baselineskip` / `\lineskiplimit` compensation to match the legacy
`\parbox[t][136bp]` behavior. `u/cover/info` uses `0pt plus 1 fill`
bottom-skip, which reproduces the oracle's `\vfill` at
`thuthesis2e/thuthesis.dtx` line 5187.
`\@@_include_graphics:nn` was promoted from the undergraduate-only section
to a shared class-level helper with `nV` variant.

## Root Cause

The initial undergraduate cover skeleton used a few approximate spacing
values that produced visible misalignment. The unconditional
`\hbox:n{}` at the top of every page instance added an unwanted baseline
that shifted the undergraduate cover down relative to the oracle.

## What Went Well

- The `top-anchor` key cleanly encodes the `\null` / no-`\null` distinction
  as a per-page choice instead of a global assumption. The default (`null`)
  preserves graduate behavior.
- Extracting the thulogo and title content into named helpers makes the
  element declarations shorter and the box-construction logic testable in
  isolation.
- The explicit `\prevdepth` / `\baselineskip` compensation in the title
  helper correctly reproduces the legacy parbox line-spacing contract
  without encoding it in the generic element template.

## What Went Wrong

- An earlier version of this reflection mischaracterized `0pt plus 1 fill`
  as an interim that should become `1.4cm`. Checking the oracle
  (`thuthesis2e/thuthesis.dtx` line 5187) confirms `\vfill` is the correct
  behavior: the info group is followed by `\vfill`, then the date block.
  The `0pt plus 1 fill` already matches this. The `1.4cm` was a leftover
  from a previous incorrect version.

## Missing Docs or Signals

| # | Gap | Where it should go |
|---|---|---------------------|
| 1 | `top-anchor` page-template key is undocumented outside the `.dtx` source | `reference/cover-structure-and-todo.md` |
| 2 | `u/cover/name-img` → `u/cover/thulogo` rename is not reflected in the reference doc | `reference/cover-structure-and-todo.md` |
| 3 | `\@@_u_cover_title:` box construction logic (prevdepth + baseline compensation) is undocumented | `reference/cover-structure-and-todo.md` |
| 4 | `u/cover/info` fill-based spacing is `0pt plus 1 fill` (matches oracle `\vfill` at line 5187); `cover-structure-and-todo.md` previously mischaracterized this as an interim | `reference/cover-structure-and-todo.md` |

## Promotion Candidates

- **`reference/cover-structure-and-todo.md`**: Document the `top-anchor` key,
  rename `name-img` → `thulogo`, add the title box construction notes, mark
  correct info spacing description (oracle `\vfill`, not `1.4cm`), note
  `include_graphics` promotion to class-level.
