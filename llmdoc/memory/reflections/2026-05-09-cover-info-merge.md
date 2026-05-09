# 2026-05-09 Undergraduate/Graduate Cover Info Merge

## Task

Merge the parallel `\@@_u_cover_info:*` and `\@@_g_cover_info:*` function
families into a single parameterized info-drawing system at class level.

## Summary

The two info-drawing systems identified as structurally identical in the
previous reflection were merged. The unified system lives under the `class`
guard with shared function names (no `_u_` or `_g_` prefix on item/row
generators). The key structural changes:

### Dimension state: function parameters → class-level variables

The old `NN` parameter-passing pattern (where strut height/depth registers
were threaded through every function signature) was replaced by two class-level
dimension variables:

- `\l_@@_strutheight_dim` / `\l_@@_strutdepth_dim`: strut metrics, set once
  by `\@@_cover_info_dims:`.
- `\l_@@_coverlabel_dim` / `\l_@@_covertext_dim`: label geometry, also set
  by `\@@_cover_info_dims:` with per-family docstrip splits.

This eliminated the `NN` suffix from every function that previously threaded
dims — signatures dropped from `\@@_u_cover_info_item:NN` to
`\@@_cover_item_info:` (and its `n`-type variants).

### Left indent: hardcoded → named constant

The left indent was extracted into a new docstrip-split dimension constant:

| Constant | `def-u` | `def-g` |
|----------|---------|---------|
| `c left wd` | `81bp` | `2.3cm` |

`\@@_cover_info_body:` reads it via `\c_@@_cleftwd_dim`.

### Label/text width: row-local → dims-setup

The label/text width adaptation (undergraduate: wider when co-supervisor
exists; graduate: fixed) moved from the row function into
`\@@_cover_info_dims:`, which now handles both strut dims and label geometry
in one setup step.

### Naming convention change: `_cover_X_item` → `_cover_item_X`

The unified functions follow `item_type` / `row_type` suffix order:

| Old (forked) | New (unified) |
|---|---|
| `\@@_u_cover_info_item:NN` | `\@@_cover_item_info:` |
| `\@@_u_cover_author_item:NN` | `\@@_cover_item_author:` |
| `\@@_u_cover_stuid_item:NN` | `\@@_cover_item_stuid:` |
| `\@@_u_cover_supv_item:NN` | `\@@_cover_item_supv:` |
| `\@@_u_cover_info_row:NNn` | `\@@_cover_row_info:n` |
| `\@@_u_cover_author_row:NN` | `\@@_cover_row_author:` |
| `\@@_u_cover_supv_row:NNn` | `\@@_cover_row_supv:n` |

### Dead code removal

Four old helpers that were only used by the already-removed generic
`\@@_cover_info:` system were deleted:

- `\@@_name_gset_eq:nn`
- `\@@_format_name:NNn`
- `\@@_format_author:`
- `\@@_format_supv:` / `\@@_format_supv_aux:n`

### Call site simplification

- `\@@_u_cover_info:` → just `\@@_cover_info_body:`
- `\@@_g_cover_info_box:nn` → calls `\@@_cover_info_body:` instead of
  `\@@_g_cover_info_body:NN`

## What Went Well

- The `NN`→class-variable transformation is the right call. Every function
  that threaded `#1`/`#2` dims was doing so only because the dims were local;
  making them class-level variables eliminates noisy signatures without
  losing clarity (the setup is a single `\@@_cover_info_dims:` call at the
  top of `\@@_cover_info_body:`).
- Extracting `c left wd` as a named constant makes the left-indent difference
  between undergraduate and graduate explicit and greppable.
- The suffix-order naming (`_item_info`, `_row_author`) reads more naturally:
  the first token says what kind of thing it is, the second says which
  variant.
- Deleting the four old helpers is safe cleanup — no remaining call sites.

## What Could Be Better

- `\@@_u_cover_info_table:` retains its `_u_` prefix even though it is now
  shared by both undergraduate and graduate call sites. The name should be
  `\@@_cover_info_table:` to match the rest of the unified naming convention.

## Missing Docs or Signals

| # | Gap | Where it should go |
|---|-----|-------------------|
| 1 | The merge from two `_u_`/`_g_` families to unified `_item_`/`_row_` naming is undocumented | `reference/cover-structure-and-todo.md` |
| 2 | `c left wd` dimension constant is undocumented | `reference/cover-structure-and-todo.md` |
| 3 | `\l_@@_strutheight_dim` / `\l_@@_strutdepth_dim` class-level variables are undocumented | `reference/cover-structure-and-todo.md` |
| 4 | `\@@_u_cover_info_table:` should be renamed to `\@@_cover_info_table:` | `reference/cover-structure-and-todo.md` |
| 5 | The old `\@@_name_gset_eq:nn`, `\@@_format_*` helpers were deleted | `reference/cover-structure-and-todo.md` |

## Promotion Candidates

- **`reference/cover-structure-and-todo.md`**: Replace the "Undergraduate
  info-system fork" section with a "Unified cover info system" section
  describing the merged architecture. Mark the merge TODO as done. Add a
  minor TODO for renaming `\@@_u_cover_info_table:`.
- **Memory only**: The lesson that dimension state should be class-level
  variables (not threaded parameters) when all callers in the same rendering
  pass need the same values. This is a recognized expl3 pattern: use `_dim`
  variables over parameter threading for shared render state.
