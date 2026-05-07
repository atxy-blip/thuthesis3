# Graduate Cover Info Block

This reflection records the 2026-05-07 cleanup of the graduate Chinese cover
information block in `source/thuthesis3.dtx`.

## What Changed

- Replaced the math-mode `\vcenter` construction in `\@@_g_cover_info_body:NN`
  with a LaTeX3 box helper, `\@@_box_vcenter:n`.
- Kept the original `thuthesis` cover geometry:
  - graduate academic info wrapper: `\parbox[t][7.25cm][t]{\textwidth}`;
  - graduate professional info wrapper: `\parbox[t][5.25cm][b]{\textwidth}`
    followed by `62pt`;
  - info table left offset: `2.3cm` plus the old `tabular` left padding `6pt`;
  - label box/text/colon widths: `2.85cm`, `2.75cm`, `.77cm`;
  - row strut split: `0.7/0.3` of the current `31.2bp` line skip.
- Split the info block into storage-aware generation phases:
  - normal rows (`dept`, `discip`, `author`, `stuid`) read
    `g_@@_info_<item>_tl`;
  - supervisor rows (`a`, `b`, `c`) read
    `g_@@_info_supv<letter>_clist`;
  - both groups share one row-geometry helper.
- Removed the graduate info block's dependency on `\@@_format_supv:`. Keep
  `\@@_format_supv:` for the generic `\@@_cover_info:` path until the
  undergraduate cover info path is refactored.
- Documented intentional expl3 argument forwarding in
  `reference/latex3-patterns-from-njuthesis.md`; a wrapper such as
  `\@@_g_cover_supv:n` may deliberately omit `#1` and pass following input
  tokens to a callee with fixed leading scratch arguments.

## Design Guidelines

- Keep layout helpers out of cover-specific code when they describe a general
  box operation. `\@@_box_vcenter:n` belongs with the box helpers, not inside
  the graduate cover renderer.
- Preserve original `thuthesis` dimensions as named implementation knowledge in
  `.dtx` comments. Do not hide visual parity behind unexplained offsets.
- Separate data groups before row generation. Do not mix normal token-list info
  and supervisor clists in one large conditional; generate normal rows and
  supervisor rows separately.
- Use small `:nF` predicate wrappers when only the false branch is needed:
  `\@@_info_if_empty:nF` and `\@@_supv_if_empty:nF` make the storage type clear
  without forcing callers to spell `\tl_if_empty:cF` or `\clist_if_empty:cF`.
- Share only the true common abstraction. For the graduate info block, the row
  geometry is common; value lookup is not.
- For rapid cover layout work, follow the PDF-only verification policy: use
  focused fixture compiles and bbox or visual comparisons against the original
  `thuthesis` output; do not run `l3build check` as the ordinary feedback loop.

## Verification Notes

The focused checks used for this cleanup were:

- `l3build unpack`;
- compiling `temp/01-title-page-doctor-1-1.tex` and
  `temp/01-title-page-doctor-1-2.tex` against `build/unpacked`;
- bbox spot checks for `01-title-page-doctor-1-1` against the original
  `thuthesis` cover output.

