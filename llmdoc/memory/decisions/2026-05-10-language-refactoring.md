# Decision: `language` and Local Language Refactoring

Date: 2026-05-10

## Context

The `language` and `main-language` implementation in `thuthesis2e` has several
problems:

- The two keys behave inconsistently between preamble and document body:
  setting `language` in the preamble cascades to update `main-language`, but
  in the body it does not. This difference is implemented via an implicit
  `\ifx\@begindocumenthook\@undefined` check.
- Environments (e.g. `abstract`, `survey`, `translation`) temporarily switch
  language via `\thusetup{language=...}`, then call
  `\thu@reset@main@language` to restore. This pattern exposes an internal
  development mechanism in the user namespace, and manual reset is easy to
  forget.
- Earlier `thuthesis3` code made both keys set the same global bool
  `\g_@@_opt_chinese_bool` with no distinction.
- Current `thuthesis3` also stores the selected language in
  `\g_@@_opt_language_tl`, but `language` and `main-language` still write the
  same global state.

## Decision

### User Interface Direction

Long-term semantics should separate thesis-wide language from local
writing-language features:

| Key | Meaning | Scope |
|---|---|---|
| `main-language` | Primary language of the thesis | Chapter heading format, ToC style, bibliography format, indentation, math style |
| `language` | Compatibility key during transition | Avoid using as an internal state machine |
| `\thusetchinese` / `\thusetenglish` | Local writing-language declaration | Feature-list switch such as punctuation, names, siunitx, minted |

The local declarations take an optional feature list. The default source list is
currently `punctuation,names,siunitx,minted`.

### Current Implementation

The current source has implemented part of the feature-list architecture:

- `language` and `main-language` are both class options in `thu / option`.
- Both keys update `\g_@@_opt_language_tl` and `\g_@@_opt_chinese_bool`.
- Both keys are also exposed through top-level `\thusetup` aliases to the
  `option` family.
- `\thusetchinese` and `\thusetenglish` are generated user declarations with a
  feature-list optional argument.
- Implemented feature functions: punctuation, siunitx, and minted.

Known gaps in the current source:

- The default feature list includes `names`, but the matching feature
  functions are not yet defined.
- State splitting between a global `main-language` and a local `language` is
  not yet complete.

## Consequences

- Do not call `\thusetup{language=...}` from template internals.
- Template internals should call the narrowest feature function needed. The
  undergraduate cover English title currently calls only English punctuation.
- Before relying on `\thusetenglish` as a full replacement for legacy body
  `\thusetup{language=english}`, finish the `names` and package-hook gaps.
- If the final policy is that `language` is class-option-only, remove or
  deprecate the current top-level `\thusetup` aliases for `language` and
  `main-language`.
