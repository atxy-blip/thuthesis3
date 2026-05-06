# Decision: PDF-Only Verification During Rapid Template Development

Date: 2026-05-06

## Context

The cover template is under fast development. Running `l3build check` compares
`.tlg` (test log) output for byte-level equivalence, but during rapid iteration
the internal macro ordering and formatting change constantly. Regenerating
`.tlg` files for every small change is high-friction and provides little value
when the goal is visual correctness, not log-level byte identity.

## Decision

During the current rapid template development phase, skip `l3build check`.
Verify correctness via PDF visual comparison only — the output should look
visually identical to the legacy `thuthesis2e` output.

Use `latexpagediff` or side-by-side PDF inspection to confirm visual equivalence.

## Consequences

- `.tlg` files will become stale during this phase. Regenerate them once the
  template stabilizes.
- `l3build doc` and `l3build install` should still pass.
- This is a temporary phase exception, not a permanent policy change. Resume
  `l3build check` once template development slows down.
