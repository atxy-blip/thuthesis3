# 2026-05-09 Undergraduate Cover Info Fork

## Task

Fork the graduate Chinese cover info drawing mechanism to the undergraduate
cover, replacing the old generic `\@@_cover_info:` with a structured info-table
system that passed PDF overlay verification against the oracle.

## Summary

The undergraduate cover info section was rebuilt using the same architectural
pattern as the graduate Chinese cover:

- `\@@_u_cover_info:` → `\@@_u_cover_info_box:` (fixed-height box wrapper)
- `\@@_u_cover_info_body:NN` → left indent `81bp + 6pt`
- `\@@_u_cover_info_dims:NN` → strut height/depth from `0.7/0.3` of
  `\baselineskip` (matches `array` strut distribution with `\arraystretch=1`)
- `\@@_u_cover_info_table:NN` → `\@@_box_vcenter:n` (same centering primitive
  as graduate)
- Per-item generators: `info_item` (maps `\c_@@_name_coveritem_clist`),
  `author_item`, `stuid_item` (conditional on `\g_@@_opt_proposal_bool`),
  `supv_item` (maps `a, b, c`)
- `\@@_u_cover_info_row:NNnn` → shared row geometry:
  `label box → colon → value → 6pt`, with label width adapting when
  co-supervisor exists (`2.5cm`/`4em` without supvc, `86bp`/`5em` with)
- `\@@_u_cover_info_row:NNn`, `\@@_u_cover_author_row:NN`,
  `\@@_u_cover_supv_row:NNn` → three value-formatting paths on shared geometry

The old generic `\@@_cover_info:` and its `\@@_cover_info_aux:NN` /
`\@@_cover_info_aux:N` helpers (which used `\clist_map_inline:Nn` with
`\@@_get_max_info_width:NN`) were removed entirely, as no other call site
used them.

`\@@_cover_format_name:n` and `\@@_cover_format_title:n` were split by
docstrip guard because the undergraduate layout contract differs:

| Helper | `def-u` | `def-g` |
|--------|---------|---------|
| `\@@_cover_format_name:n` | `4em` stretch + `1.5em` gap | `3cm` pad + `4em` stretch |
| `\@@_cover_format_title:n` | `2.5em` stretch | `3em` stretch |

The undergraduate info element format changed from `\@@_zihao:nn { 2.32 } { 3 }`
to `\@@_fontsize:nn { 16 bp }{ 30.96 bp }`, with `align = l` added. The colon
width constant for `def-u` changed from `16.06pt` to `.82cm` (was `def-g`'s old
value; `def-g` moved to `.77cm`).

PDF overlay verification passed against the oracle.

## What Went Well

- Forking the graduate pattern to undergraduate was straightforward because
  the structural decomposition (box wrapper → dims → table → items → rows)
  was already validated by the graduate parity work.
- Removing the old generic `\@@_cover_info:` was safe because no other call
  sites depended on it after the graduate cover had its own info system.
- The label-width adaptation for co-supervisor presence correctly reproduces
  the oracle's behavior where the label column widens from `2.5cm` to `86bp`
  when `supvc` exists.
- The `\@@_cover_format_*` docstrip split is clean: undergraduate and
  graduate have genuinely different spacing contracts, so compile-time
  dispatch is appropriate.

## What Went Wrong

- The two info-drawing mechanisms (`\@@_u_cover_info_*` and
  `\@@_g_cover_info_*`) are structurally identical: both use the same
  `\@@_box_vcenter:n`, the same `0.7/0.3` strut dims, the same item/row
  decomposition, and the same three value-formatting paths. Only the left
  indent (`81bp+6pt` vs `83bp+6pt`), label widths, and name/title stretch
  parameters differ. These should be one parameterized system rather than
  two parallel `_u_` / `_g_` function families.

## Root Cause

When the graduate info system was first built, the undergraduate cover still
used the generic `\@@_cover_info:`. Forking was the right first step to
prove the pattern works for undergraduate, but the duplication should be
resolved before it calcifies.

## Missing Docs or Signals

| # | Gap | Where it should go |
|---|-----|-------------------|
| 1 | The `_u_` / `_g_` info-drawing fork is undocumented | `reference/cover-structure-and-todo.md` |
| 2 | `\@@_cover_format_name:n` / `\@@_cover_format_title:n` are now docstrip-split, not shared | `reference/cover-structure-and-todo.md` |
| 3 | Old `\@@_cover_info:` removal is undocumented | `reference/cover-structure-and-todo.md` |
| 4 | `c colon wd` constants changed (`def-u`: `16.06pt`→`.82cm`, `def-g`: `.82cm`→`.77cm`) | `reference/cover-structure-and-todo.md` |

## Promotion Candidates

- **`reference/cover-structure-and-todo.md`**: Document the info-system fork,
  update the shared helper section to reflect the docstrip split, add a merge
  TODO for unifying the two parameterized systems.
- **Memory only**: The lesson that forking-then-merging is a valid two-step
  strategy — proving correctness first with a fork, then deduplicating with
  parameterization — applies beyond this specific case.

## Next Step

Merge `\@@_u_cover_info_*` and `\@@_g_cover_info_*` into a single
parameterized info-drawing system. The two differ only in left indent,
label widths, name/title formatting parameters, and the author row's
value formatter. These can be encoded as function signatures, key-value
options, or docstrip constants.
