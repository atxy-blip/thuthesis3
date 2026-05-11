# Language Interface

Use this reference when changing `language`, `main-language`, or local language
switching in `source/thuthesis3.dtx`.

## Current Source State

`source/thuthesis3.dtx` currently keeps one language token list,
`g opt language tl`, and one Chinese-language bool, `g opt chinese bool`.
Both `language` and `main-language` in the `thu / option` key family write
the same state.

The same two keys are also exposed as top-level `\thusetup` aliases to the
`option` key family. This is current implementation state, not the desired
end point if `language` is later made class-option-only.

## Local Language Declarations

The new local user-facing declarations are `\thusetchinese` and
`\thusetenglish`. They accept an optional comma list of language features.
The current default list is `punctuation,names,siunitx,minted`.

Implemented feature functions in the current source:

- `punctuation`: `@@ chinese punctuation` / `@@ english punctuation`, matching
  the old punctuation character-class switch.
- `siunitx`: `@@ chinese siunitx` / `@@ english siunitx`, matching old list
  and range word setup.
- `minted`: `@@ chinese minted` / `@@ english minted`, matching old minted
  listing float names.

Known implementation gaps:

- `names` is in the default feature list, but matching `@@ chinese names` and
  `@@ english names` functions are not yet present.
- Local language declarations are intended to be scoped by the surrounding TeX
  group. Current source should be audited before relying on every feature being
  group-contained.

## Design Direction

Keep thesis-wide language decisions separate from local writing-language
features:

- `main-language`: thesis-wide state for headings, contents, bibliography,
  indentation, math style, and similar document contracts.
- `language`: inherited compatibility state while the transition is incomplete.
- `\thusetchinese` / `\thusetenglish`: content-level declarations for local
  feature switching.

Template internals should call the narrowest feature function they need. For
example, the undergraduate cover English title uses only English punctuation,
not the full local language declaration.

## Oracle Notes

In `thuthesis2e`, `\thusetup{language=english}` in the undergraduate cover
English-title branch does not select the serif font. The serif Latin output is
caused by the title format using CJK-only `\heiti`, which leaves Latin letters
in the current roman/main font.
