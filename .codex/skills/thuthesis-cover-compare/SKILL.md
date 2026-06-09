---
name: thuthesis-cover-compare
description: Use when verifying ThuThesis cover/title-page visual parity between the thuthesis2e oracle and thuthesis3, especially for PDF overlay checks, pdftotext bbox coordinate checks, title-page fixtures, cover spacing, font, underline, or absolute-position regressions.
---

# ThuThesis Cover Compare

## Overview

Use the sibling `thuthesis2e` title-page fixtures as the oracle for layout-sensitive cover work in `thuthesis3`. Prefer PDF and bbox evidence over visual judgement alone.

## Quick Start

From `C:\Users\admin\Documents\Source\thuthesis3`, run:

```powershell
powershell -ExecutionPolicy Bypass -File .codex\skills\thuthesis-cover-compare\scripts\compare-cover.ps1 -Fixture 01-title-page-postdoc-1
```

For a focused top-of-page check, compare only the first N text elements:

```powershell
powershell -ExecutionPolicy Bypass -File .codex\skills\thuthesis-cover-compare\scripts\compare-cover.ps1 -Fixture 01-title-page-postdoc-1 -FirstWords 10
```

Use `-OutRoot <path>` to place outputs in a separate investigation directory.
Relative `-OutRoot` values are resolved before compilation so overlay generation
can safely run from the output directory.

The script reads matching fixtures from:

- `C:\Users\admin\Documents\Source\thuthesis2e\testfiles\01-title-page`
- `C:\Users\admin\Documents\Source\thuthesis3\testfiles\01-title-page`

It writes outputs under `.llmdoc-tmp\cover-compare\<fixture>\`:

- `2e\<fixture>.pdf`: oracle PDF
- `thuthesis3\<fixture>.pdf`: current PDF
- `oracle.pdf`, `actual.pdf`, `comp.tex`, and `comp.pdf`: `pdfpagediff` overlay inputs/output, modeled after `temp/comp.tex` and compiled with `pdflatex`
- `bbox-2e.html` and `bbox-thuthesis3.html`: `pdftotext -bbox` outputs
- `bbox-diff.txt`: exact `<word>` line comparison

Exit code `0` means the compared `<word>` bbox lines match exactly. Exit code `2` means the PDFs compiled but the compared text bboxes differ.

## Workflow

1. Read project `llmdoc/` first, especially `startup.md`, `must/testing-and-oracle-policy.md`, and `reference/latexpagediff-verification.md`.
2. Pick one fixture that isolates the cover surface being debugged.
3. Run `compare-cover.ps1 -Fixture <name-with-or-without-.tex>`.
4. For source edits, let the script run `l3build install`; use `-NoInstall`
   only after confirming `build/local` already reflects `source/thuthesis3.dtx`.
5. Inspect `comp.pdf` first for visual overlay differences.
6. Inspect `bbox-diff.txt` when exact position, font, or spacing parity matters.
7. If bbox differs, inspect the fixture logs or rerun the fixture with TeX box tracing before changing `source/thuthesis3.dtx`.

## Notes

- Edit `source/thuthesis3.dtx`, never generated `.cls` or `.def` files.
- Keep temporary comparison artifacts in `.llmdoc-tmp/`, not `llmdoc/`.
- `l3build install` may print Windows access-denied noise while still producing usable files; trust the command exit code and generated `build/local` files.
- Use the full `thuthesis2e` fixture as the oracle; do not rewrite oracle fixtures unless the user explicitly asks for test maintenance.
- Compile the cover fixtures with `xelatex`; compile the `pdfpagediff` overlay with `pdflatex`.
- `pdfpagediff` strips directory components internally, so the script copies PDFs to `oracle.pdf` and `actual.pdf` beside `comp.tex` before layering.
- Default comparison is all PDF text elements. Use `-FirstWords N` only for deliberately focused checks such as the postdoc top information bar or the `cover-p-b` title block.
