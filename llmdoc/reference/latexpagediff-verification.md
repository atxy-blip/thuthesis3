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

## Cover Page Fixture Workflow

For title-page and cover layout work, compare one isolated fixture against the
`../thuthesis2e` oracle before broadening the change to the full fixture set.
The doctor academic Chinese cover without secret is:

- oracle implementation: `../thuthesis2e/thuthesis.dtx`,
  `\thu@titlepage@thesis`;
- local fixture: `testfiles/01-title-page/01-title-page-doctor-1-1.tex`;
- temporary comparison files used during layout debugging:
  `temp/01-title-page-doctor-1-1-2e.tex`,
  `temp/01-title-page-doctor-1-1.tex`, and `temp/comp.tex`.

During active cover-layout development, do not run `l3build check` as the
ordinary feedback loop. Use whichever local docstrip/build step has generated
the current `thuthesis3.cls` and family `.def` files, then compare PDFs. Compile
from `temp/`, with the current directory first in `TEXINPUTS`.
This avoids accidentally using l3build's copied regression-test wrapper instead
of the hand-edited temporary file:

```powershell
$env:TEXINPUTS='.;C:/Users/admin/Documents/Source/thuthesis3/build/test-testfiles/config-title-page;'
xelatex -interaction=nonstopmode -halt-on-error "01-title-page-doctor-1-1.tex"
```

Use `pdfpagediff` for the first visual pass:

```latex
\documentclass{article}
\usepackage{pdfpagediff}
\begin{document}
\layerPages{01-title-page-doctor-1-1.pdf}{01-title-page-doctor-1-1-2e.pdf}
\end{document}
```

When the overlay shows a vertical mismatch, extract text bounding boxes so the
comparison has numbers instead of only visual judgement:

```powershell
pdftotext -bbox temp\01-title-page-doctor-1-1-2e.pdf temp\bbox-2e.html
pdftotext -bbox temp\01-title-page-doctor-1-1.pdf temp\bbox-3.html
Select-String -Path temp\bbox-2e.html,temp\bbox-3.html -Pattern "单位根|理论|申请|应用经济学|二〇〇二"
```

For the `cover-g-zh` doctor academic page, the parity target after the vskip
and info-row fixes is exact alignment for the visible text bboxes:

| Text item | Oracle yMin | thuthesis3 yMin |
| --- | ---: | ---: |
| title first line | `180.789` | `180.789` |
| title second line | `227.589` | `227.589` |
| degree/category line | `282.189` | `282.189` |
| department value | `450.180` | `450.180` |
| discipline value | `481.380` | `481.380` |
| author value | `512.580` | `512.580` |
| supervisor value | `543.780` | `543.780` |
| date | `648.035` | `648.035` |

If the bboxes disagree but the source skips appear identical, inspect the
shipped page boxes. This is the most direct way to tell whether a mismatch
comes from explicit `\vskip`, from an inserted top/baseline glue, or from font
metrics:

```powershell
$env:TEXINPUTS='.;C:/Users/admin/Documents/Source/thuthesis3/build/test-testfiles/config-title-page;'
xelatex -interaction=nonstopmode -halt-on-error "\tracingoutput=1\showboxbreadth=10000\showboxdepth=10000\input{01-title-page-doctor-1-1.tex}"
xelatex -interaction=nonstopmode -halt-on-error "\tracingoutput=1\showboxbreadth=10000\showboxdepth=10000\input{01-title-page-doctor-1-1-2e.tex}"
```

In the successful `cover-g-zh` title/degree comparison, both implementations
show the same top sequence:

```text
\glue(\topskip) 12.0
\hbox(0.0+0.0)x0.0
\glue 8.1
\glue(\parskip) 0.0 plus 1.0
\glue(\parskip) 0.0
\glue(\baselineskip) 6.96352
\hbox(13.11148+43.79402)x398.3386
\glue 40.5
...
\glue 24.1
```

This trace is the useful diagnostic artifact: it shows that the page top must
behave like legacy `\null\vskip`, and that the inter-element skip after the
title must remain ordinary vertical glue.

For the info block, also compare the row/table internals in the shipped-box
trace. The old `tabular` contributes `6pt` left/right table padding and array
struts with `0.7/0.3` of the row skip; if the LaTeX3 box version omits those,
the x coordinates or row baselines will be wrong even though the source no
longer contains a `tabular`.
