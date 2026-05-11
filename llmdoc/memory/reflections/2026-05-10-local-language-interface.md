# 2026-05-10 Local Language Interface

## Task

Reflect on the partial replacement for using `\thusetup{language=english}`
inside document content and internal template code.

## Summary

Legacy `thuthesis2e` uses `\thusetup{language=english}` both as a user
configuration interface and as an internal local-language switch. This mixes
separate responsibilities:

- `main-language` controls thesis-wide behavior such as chapter names,
  heading/TOC format, indentation, bibliography format, and math style.
- `language` controls local writing-language behavior such as punctuation
  character classes, local names, `siunitx` separators, table font, and listing
  names.
- Internal cover and frontmatter code often needs only one part of the local
  behavior, but calling `\thusetup{language=...}` reruns the full public key
  machinery.

The cleaner design is now partially implemented as dedicated local-language
declarations such as `\thusetenglish[punctuation,names,siunitx,minted]`, with
a matching Chinese form. The optional argument is a feature list, not a
key-value setup interface.

## Undergraduate Cover Font Lesson

The oracle undergraduate cover English title is roman/main-font text because
legacy `\thu@titlepage@bachelor` applies `\heiti` in the title parbox, not
`\sffamily`. In `thuthesis2e`, `\heiti` is effectively `\CJKfamily{zhhei}`;
it changes the CJK family but leaves Latin letters in the current roman family.

Therefore, the old English title's serif appearance is not caused by
`\thusetup{language=english}`. That call mainly changes local language
side effects such as punctuation character classes. In `thuthesis3`, if the
undergraduate title element uses `\heiti`, the English title can match the
oracle without adding `\normalfont` as a compensation for an outer `\sffamily`.

## Interface Shape

`\thusetenglish` should be a declaration whose effects are scoped by the
surrounding TeX group:

- `\thusetenglish` defaults to the full legacy local-language behavior.
- `\thusetenglish[punctuation]` only changes punctuation character classes.
- `\thusetenglish[punctuation,names,siunitx,minted]` spells out the full
  current feature set.

Known features:

- `punctuation`: Unicode punctuation character classes.
- `names`: local names such as figure, table, theorem, proof, algorithm.
- `siunitx`: list and range words such as `and` and `to`.
- `minted`: code listing float name from the `minted` package.

Template internals should call the narrowest internal function needed. The
current undergraduate English title branch calls the punctuation feature
directly instead of the whole user declaration.

Current source gap: the default list includes `names`, but the corresponding
feature functions are not yet defined.

## What Went Well

- Separating feature groups exposes what the old `language` switch really did.
- A declaration such as `\thusetenglish[...]` avoids reusing `\thusetup` as an
  internal state machine.
- The design keeps `main-language` as thesis-wide state while allowing local
  language changes in document content.

## What Went Wrong

- Treating the legacy cover's serif English title as a `language` side effect
  was misleading. It came from `\heiti` being CJK-only, not from language
  switching.
- A single all-or-nothing local language switch is still too coarse for
  template internals, where only punctuation may be needed.

## Root Cause

The legacy implementation grew one public key, `language`, to serve both
document content and internal template transitions. Its hooks encode multiple
independent features, so local internal needs accidentally rerun unrelated
configuration.

## Missing Docs or Signals

| # | Gap | Where it should go |
|---|-----|-------------------|
| 1 | Finish or rename the `names` feature before treating `\thusetenglish` default as complete | source follow-up |
| 2 | Decide whether top-level `\thusetup{language=...}` aliases should remain after class-option-only policy is adopted | source and manual follow-up |

## Promotion Candidates

- Promote remaining source gaps into TODOs if the language refactor continues
  across another task.
