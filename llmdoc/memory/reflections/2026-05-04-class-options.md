# 2026-05-04 Class Options Reflection

## Context

The class-option work clarified the compatibility boundary for `thuthesis3`.
The user is porting option names from `../thuthesis2e/master`, while using
NJUThesis-style LaTeX3 mechanisms only as implementation reference.

## Lessons

- Class-option inheritance means public option names, not legacy
  implementation structure.
- The oracle for option names is `../thuthesis2e/master`; do not use
  `../thuthesis2e/refactor/*` or NJUThesis as the option-name source.
- `\thusetup`-only keys from legacy ThuThesis should not be counted as missing
  class options.
- Math-related keys should be handled separately because they are not part of
  the immediate class-option inheritance check.
- Extra bootstrap options adapted from NJUThesis may remain when they keep the
  template usable and do not affect legacy tests, but they should not be
  mistaken for inherited ThuThesis API.

## Task Notes

The manual class-option section was updated to list implemented options, and
the implementation variable/key blocks were sorted to match that manual order.
During the sort, declaration mismatches became visible: `thesis-type` needed
its own proposal boolean, and `config` uses a clist variable.

