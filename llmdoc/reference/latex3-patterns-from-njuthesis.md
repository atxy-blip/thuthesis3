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

Adopted in `thuthesis3` for cover generation (`thuthesis3/cover/begin`,
`thuthesis3/cover/body`, `thuthesis3/cover/end`, and
`thuthesis3/cover/back`). Hook labels (`main`, `decl-a`, `decl-b`) and a rule
(`main < decl-a`) control execution order. Draft mode is handled by
conditionally registering hook code rather than branching inside `\maketitle`.

For back-cover declaration material, prefer the `lthooks` one-time hook model:
register the material under the semantic hook (`cover/back`), then have
`\maketitle` add next-code to the dedicated `enddocument` hook that calls
`\hook_use_once:n { thuthesis3 / cover / back }`. This avoids private boolean
state while still preventing duplicate back-cover generation.

This pattern remains a candidate for frontmatter transitions, bibliography
setup, and other begin-document ordering.

## Internal Naming

For internal expl3 helper names, prefer a semantic stem over an abbreviation
when the helper models a real layout concept. The signature already records
arity and argument types, so names should explain the operation, not merely
save characters.

Examples from the cover migration:

- keep `\@@_box_paragraph:nn` and `\@@_box_paragraph:nnn` rather than shortening
  to `\@@_box_par:nnn`; `paragraph` names the box abstraction, while `par`
  is easily confused with the primitive paragraph token;
- keep `\@@_box_pad:nn` separate from `\@@_box_left:nn`; `pad` means "use at
  least this width, but preserve natural width if content is wider", matching
  the legacy `\thu@pad` behavior;
- use abbreviations only when they are already established in the local source
  and do not obscure the behavior.

## Argument Forwarding

expl3 signatures document the public calling convention, but an implementation
may intentionally omit formal parameters when it is a thin forwarding wrapper
and the following input tokens should be consumed by the callee. This idiom also
appears in LaTeX3 sources.

Use it sparingly and only when the wrapper adds fixed leading arguments or
selects a backend while preserving the remaining call surface. For example, a
wrapper named `\@@_g_cover_supv:n` may forward to
`\@@_g_cover_supv:NNNn <scratch-clist> <scratch-tl-a> <scratch-tl-b>` and let
the caller's following `{ a }`, `{ b }`, or `{ c }` become the final `n`
argument. Do not "fix" such wrappers solely because no `#1` appears in the
definition; check whether the argument is deliberately passed through.

When using this pattern, keep the wrapper body short enough that the forwarding
is obvious, and document the intent near the macro if future readers are likely
to mistake it for a missing parameter.

## Caution

NJUThesis patterns solve NJUThesis problems. For `thuthesis3`, keep the
ThuThesis user interface and legacy behavior in view unless intentionally
changing them.
