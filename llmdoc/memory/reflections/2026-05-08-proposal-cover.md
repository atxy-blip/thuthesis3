# 2026-05-08 Graduate Proposal Cover Implementation

## Task

Implement the graduate Chinese proposal cover, including degree/category text
variant, student-id row, and supporting helpers.

## Summary

The proposal cover support was implemented through a bool-dispatch approach
inside `\@@_g_cover_degree:` rather than the separate `_thesis`/`_proposal`
CS name functions that the design docs had planned. Several new helpers and
name tokens were introduced, and all `\thusetup` key assignments were fixed
from local to global.

## What Went Well

- The single-function bool-dispatch keeps the thesis/proposal sentence
  composition visible in one place, making it easy to see the exact
  difference between the two branches (which is just composing different
  sentence fragments from name tokens).
- `\@@_parens:n` is a genuinely shared utility, correctly placed in the
  generic helper area rather than inside graduate cover code.
- `\@@_g_cover_stuid_item:NN` follows the established pattern of
  `\@@_g_cover_info_item:NN` and `\@@_g_cover_author_item:NN`.
- The `thesis _en` / `supv a` split allows the thesis/dissertation word to
  be reused in both the supervisor label and the `\c_@@_text_cover_en_tl`
  string, avoiding the former hardcoded `Dissertation~`.
- The global assignment fix was applied systematically to all keys, leaving
  no mixed local/global half-state.

## What Went Wrong

- The design docs (`cover-structure-and-todo.md` and
  `cover-xtemplate-dispatch-design.md`) prematurely committed to the
  `_thesis`/`_proposal` CS naming convention. An explicit design rationale
  was written ("avoids `\bool_if:nTF` on `\g_@@_opt_proposal_bool` inside
  the rendering function") and then explicitly set aside by the
  implementation.
- The `apply begin`/`apply end` token data change (removing literal
  parentheses) and the `\@@_parens:n` helper introduction were coupled into
  the same diff. These are two separable concerns: one is a token content
  change, the other is a new helper. Coupling them reduced atomicity and
  would make bisection harder if either direction proved wrong.

## Root Cause

The design docs recorded a presumed answer (two-function dispatch) to a
design question (how to vary the degree/category sentence by thesis type)
before the implementation explored what code shape actually makes sense.
When the difference between branches turned out to be composing a sentence
from different name tokens, the single-function approach with bool dispatch
was clearly better -- but the docs had already set expectations for the
two-function approach.

The proper sequence would have been: record the design question and its
constraints in the doc, implement a first pass, then document the chosen
approach with its rationale.

## Missing Docs or Signals

These gaps remain in `llmdoc/` and should be addressed in a docs update:

| # | Gap | Where it should go |
|---|-----|-------------------|
| 1 | `cover-structure-and-todo.md` lines 164-173 still describe `_thesis`/`_proposal` CS naming convention as the planned method | Replace with actual bool-dispatch approach and rationale |
| 2 | `cover-xtemplate-dispatch-design.md` line 41-42 lists thesis-type as "CS name suffix" | Replace thesis-type entry: it is now a bool used for inline dispatch |
| 3 | `cover-xtemplate-dispatch-design.md` section (lines 336-353) describes two-function approach with explicit anti-bool-dispatch rationale | Remove or replace with the actual single-function approach |
| 4 | `\@@_parens:n` and `paren l`/`paren r` name tokens are undocumented | `reference/cover-structure-and-todo.md` or a new name-tokens reference |
| 5 | `proposal` name token (`学位论文选题报告`) is undocumented | Same as above |
| 6 | `\@@_define_name_en:nn` helper is undocumented | `reference/setup-info-keys.md` or name-helper reference |
| 7 | `thesis _en`/`supv a` split and `\c_@@_text_cover_en_tl` change are undocumented | English cover reference or name-token reference |
| 8 | Global `\thusetup` assignment fix is undocumented | `reference/setup-info-keys.md` or `reference/class-options.md` |
| 9 | `\@@_g_cover_stuid_item:NN` and its table placement are undocumented | `reference/cover-structure-and-todo.md` |

## Promotion Candidates

- **`reference/cover-structure-and-todo.md`**: Must be updated to reflect the
  actual bool-dispatch approach, mark the proposal degree/category and
  student-id TODO items as done with accurate descriptions.
- **`reference/cover-xtemplate-dispatch-design.md`**: Must be updated to
  remove the `_thesis`/`_proposal` CS naming convention, replace the
  thesis-type slug description, and remove the section that explicitly
  argues against bool dispatch.
- **A new name-tokens reference page** (or extension of an existing one):
  The collection of new name tokens (`paren l`, `paren r`, `proposal`,
  `thesis _en`) and helpers (`\@@_parens:n`, `\@@_define_name_en:nn`)
  deserves a single stable location. Currently no llmdoc document catalogs
  the name-token namespace.
- **Memory only** (do not promote): The lesson that design docs should
  record design questions and constraints before recording presumed answers.
  This is a process lesson for the team, not a stable doc the codebase
  needs to consult at build time.

## Follow-up

Ask the user whether to run `/llmdoc:update` to bring
`cover-structure-and-todo.md` and `cover-xtemplate-dispatch-design.md` into
line with the implemented code, and to document the new helpers and name
tokens.
