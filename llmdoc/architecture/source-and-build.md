# Source and Build Architecture

## Source Layout

The source of truth is `source/thuthesis3.dtx`.

Docstrip targets declared in the `.dtx` generate:

- `thuthesis3.cls`;
- `thuthesis3-undergraduate.def`;
- `thuthesis3-graduate.def`;
- `thuthesis3-postdoctoral.def`;
- `thuthesis3.ins` for internal source extraction.

The implementation uses the internal module prefix `thu` through
`%<@@=thu>`.

## Major Implementation Sections

Important sections in `source/thuthesis3.dtx`:

- preparation and engine checks;
- variable declarations;
- internal helper functions;
- `xtemplate` page and element objects;
- messages;
- class options and `\ProcessKeysOptions`;
- user setup interface;
- package loading and configuration;
- personal information keys;
- font setup;
- page layout;
- headings and contents;
- bibliography and citations;
- footnotes, figures, tables, lists, theorem, and math style;
- cover, copyright, abstract, acknowledgement, achievements, notation, and
  constants (cover generation now uses LaTeX3 hook mechanism: `cover/begin`,
  `cover/body`, `cover/end`, and `cover/back`; `cover/back` is linked to the
  dedicated `enddocument` hook only from `\maketitle`).

## Build System

`build.lua` uses l3build with:

- `module = "thuthesis3"`;
- `checkengines = {"xetex"}`;
- `checkopts = "-interaction=batchmode"`;
- `checkconfigs = {"build", "testfiles/config-title-page"}` with additional
  title-page-related configs left commented for future expansion;
- `typesetexe = "xelatex"`;
- `typesetfiles = {"thuthesis3.dtx"}`;
- `unpackexe = "xetex"`;
- `unpackfiles = {"thuthesis3.dtx"}`.

There is also a custom `save-all` target that iterates over configured test
configs and saves the discovered tests for each config.

The README preview path is:

```sh
l3build install
xelatex docs/thuthesis-example.tex
```

## Generated Files

Do not edit generated `.cls` or `.def` files directly if they appear in the
working tree. Edit `source/thuthesis3.dtx`, then regenerate through l3build.

## Test Layout

Focused setup-key tests live directly under `testfiles/`. Title-page tests live
under `testfiles/01-title-page/` and are selected by
`testfiles/config-title-page.lua`. The imported title-page corpus is broader
than the default smoke subset, so expanding `includetests` in that config should
be a deliberate verification step rather than a drive-by change.
