---
name: Cover hook implementation reflection
description: Notes on implementing hook-based cover generation, 2026-05-04
type: feedback
---

Cover generation refactored to use LaTeX3 hook mechanism.

**Pattern:** Four hooks (`thuthesis3/cover/begin`, `thuthesis3/cover/body`,
`thuthesis3/cover/end`, `thuthesis3/cover/back`) replace direct function calls.
Hook labels (`main`, `decl-a`, `decl-b`, `presetup`, `postsetup`) identify
logical units within the flow.  A rule (`main < decl-a`) guarantees main cover
content precedes declaration pages that belong immediately after the cover.
The `decl-b` code belongs to `cover/back`, not directly to document end.

**What worked:**
- Hook naming convention `thuthesis3/<module>/<phase>` mirrors NJUThesis and
  is clear for future extension.
- Rule-based ordering eliminates fragile sequential code in `\maketitle`.
- Moving `\cleardoublepage` into `env/document/end` via
  `\hook_gput_next_code:nn` is cleaner than embedding it in cover logic.
- Draft-mode guard moved from `\maketitle` to conditional hook registration,
  keeping `\maketitle` as a small hook anchor rather than a place for page
  selection logic.
- For 封底-style declaration pages, `\maketitle` schedules
  `\hook_use_once:n { thuthesis3 / cover / back }` on the dedicated
  `enddocument` hook. This follows `lthooks` one-time hook semantics and avoids
  a separate boolean guard.

**Watch out for:**
- `\hook_use:n` requires the full hook name; the `.` shorthand works for
  `\hook_new:n` and `\hook_gput_code:nnn` but not for `\hook_use:n`.
- `\hook_gput_next_code:nn` is one-shot, not unique: multiple declarations
  before the target hook fires will all run. If repeated scheduling is possible,
  put the uniqueness at the semantic hook execution point with
  `\hook_use_once:n`.
- Prefer the dedicated `enddocument` hook family over the generic
  `env/document/end` hook when connecting code to `\end{document}` behavior.
- Hook-based reordering causes l3build `.tlg` checks to fail even when PDF
  output is identical.  The cover pages were verified with latexpagediff
  (overlay comparison against `/temp/comp.tex`) and show no visual
  difference — the `.tlg` changes are expected internal reordering, not
  regressions.  See `llmdoc/reference/latexpagediff-verification.md` for
  the verification workflow.
