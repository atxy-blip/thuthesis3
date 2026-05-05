---
name: latexpagediff visual verification
description: How to verify visual equivalence when l3build .tlg tests fail after internal reordering
type: reference
---

When an architectural change (e.g. hook-based reordering) causes l3build
`.tlg` checks to fail, the failure is expected if only internal execution
order differs.  Use `pdfpagediff` to confirm the PDF output is visually
identical.

## Minimal Example

`./temp/comp.tex`:

```latex
\documentclass{article}

\usepackage{pdfpagediff}

\begin{document}

\layerPages{thuthesis-example.pdf}{thuthesis-exampl1e.pdf}
\end{document}
```

## Workflow

1. Compile `docs/thuthesis-example.tex` with the old (pre-change) class to
   produce `thuthesis-example.pdf`.
2. Install the new class (`l3build install`) and compile again, renaming the
   output to `thuthesis-exampl1e.pdf`.
3. Compile `temp/comp.tex` — the overlay shows any visual differences as
   colored regions.
4. If the overlay is clean, the `.tlg` changes are internal reordering and
   the `.tlg` files should be regenerated with `l3build save`.
