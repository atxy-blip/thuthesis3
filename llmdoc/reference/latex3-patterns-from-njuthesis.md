# LaTeX3 Patterns from NJUThesis

Use this as a quick reference for technology patterns that may be adapted into
`thuthesis3`.

## Configuration

`../NJUThesis-njulug/source/njuthesis.dtx` uses:

- `l3keys2e` for class options;
- module keys under the project namespace;
- a public setup command with optional module selection;
- top-level module forwarding for grouped setup like `\njusetup[info]{...}`.

For `thuthesis3`, the analogous public command is `\thusetup`, and the
namespace is `thu`.

## Filtered Key Groups

The local NJUThesis decision on 2026-05-02 says:

- keep feature-dependent keys defined;
- assign `.groups:n` to keys that should become inert under a mode or feature
  switch;
- build one global excluded-group clist after class options are processed;
- define the internal key setter once based on that clist.

This is relevant for ThuThesis features such as anonymous mode, optional math
font configuration, and any feature package that may be disabled while setup
files still contain its keys.

## Page Templates

NJUThesis uses `xtemplate` page and element instances for layout-sensitive
pages. `thuthesis3` already has analogous `thu` element and page templates in
`source/thuthesis3.dtx`.

Prefer adapting this pattern for:

- title pages;
- copyright and statement pages;
- abstract pages;
- fixed-layout special pages.

## Hooks

NJUThesis has hook-based cover generation in recent source:

- named cover begin/body/end phases;
- ordered hook rules for page parts;
- one-shot hook code for document-end cleanup.

This pattern is a candidate for ThuThesis frontmatter, cover, bibliography, and
begin-document setup ordering. Prove behavior with the `thuthesis2e` oracle
before committing to a final hook API.

## Caution

NJUThesis patterns solve NJUThesis problems. For `thuthesis3`, keep the
ThuThesis user interface and legacy behavior in view unless intentionally
changing them.
