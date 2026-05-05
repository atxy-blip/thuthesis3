# Project Overview

`thuthesis3` is a work-in-progress LaTeX3 rewrite of the ThuThesis document
class.

The README states that the class is not yet usable and should not accept pull
requests before it implements the original class's full feature set.

## Top-Level Files

- `README.md`: project status and local preview instructions.
- `README-CTAN.md`: CTAN-facing readme placeholder.
- `LICENSE`: project license.
- `build.lua`: l3build configuration.
- `docs/thuthesis-example.tex`: example document.
- `source/thuthesis3.dtx`: documented source and docstrip source of truth.

## Current Implementation Shape

`source/thuthesis3.dtx` is already an expl3 class source:

- declares `\ProvidesExplClass{thuthesis3}`;
- loads `xtemplate` and `l3keys2e`;
- supports XeTeX and LuaTeX only;
- uses `ctexbook` as the base class;
- defines `\thusetup`, `\thusetformat`, `\thusetlength`,
  `\thusetname`, and `\thusettext`;
- defines module keys under `thu / ...`;
- uses `xtemplate` page and element instances for layout-sensitive pages;
- generates covers through LaTeX3 hook phases (`cover/begin`, `cover/body`,
  `cover/end`) with rule-ordered labels (`main`, `decl-a`, `decl-b`).

## Strategic Context

This repository should not use `../thuthesis2e` as a permanent staging branch.
Instead, use `../thuthesis2e` to prove behavior and use this repository for the
coherent final architecture.
