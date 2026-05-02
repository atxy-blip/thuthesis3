# Decision: `thuthesis3` Is the LaTeX3 Destination

Date: 2026-05-02

## Context

The user is maintaining sibling repositories:

- `../thuthesis2e`, a forked version of original ThuThesis with legacy behavior
  and regression tests, corresponding to
  <https://github.com/atxy-blip/thuthesis2e>;
- `../NJUThesis-njulug`, a LaTeX3 implementation whose technology patterns are
  the intended reference, corresponding to
  <https://github.com/nju-lug/NJUThesis>;
- `thuthesis3`, the new LaTeX3 rewrite repository, corresponding to
  <https://github.com/atxy-blip/thuthesis3>.

The original upstream ThuThesis repository is
<https://github.com/tuna/thuthesis>.

The user wants to test LaTeX3 modules in `thuthesis2e`, then migrate them back
to this repository.

## Decision

Use `thuthesis3` as the final destination for LaTeX3-native architecture.

Use `../thuthesis2e/master` only for behavior-preserving cleanup, test
improvements, and oracle maintenance.

Use `../thuthesis2e/refactor/*` for focused experiments that prove a LaTeX3
idea against legacy behavior. Do not merge such branches back into
`../thuthesis2e/master` merely because they reproduce old behavior.

## Consequences

- Future implementation work here should be organized around final module
  ownership, not legacy source order.
- Behavior contracts should be proven against `../thuthesis2e`.
- Successful technology ideas may be copied from experiment branches and
  adapted into `source/thuthesis3.dtx`.
- Intentional behavior differences must be documented in this repository.
