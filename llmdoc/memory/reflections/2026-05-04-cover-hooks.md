---
name: Cover hook implementation reflection
description: Notes on implementing hook-based cover generation, 2026-05-04
type: feedback
---

Cover generation refactored to use LaTeX3 hook mechanism.

**Pattern:** Three hooks (`thuthesis3/cover/begin`, `thuthesis3/cover/body`,
`thuthesis3/cover/end`) replace direct function calls.  Hook labels (`main`,
`decl-a`, `decl-b`, `presetup`, `postsetup`) identify logical units within the
flow.  A rule (`main < decl-a`) guarantees main cover content precedes
declaration pages.

**What worked:**
- Hook naming convention `thuthesis3/<module>/<phase>` mirrors NJUThesis and
  is clear for future extension.
- Rule-based ordering eliminates fragile sequential code in `\maketitle`.
- Moving `\cleardoublepage` into `env/document/end` via
  `\hook_gput_next_code:nn` is cleaner than embedding it in cover logic.
- Draft-mode guard moved from `\maketitle` to conditional hook registration,
  making `\maketitle` a simple three-hook dispatch.

**Watch out for:**
- `\hook_use:n` requires the full hook name; the `.` shorthand works for
  `\hook_new:n` and `\hook_gput_code:nnn` but not for `\hook_use:n`.
- Hook-based reordering causes l3build `.tlg` checks to fail even when PDF
  output is identical.  The cover pages were verified with latexpagediff
  (overlay comparison against `/temp/comp.tex`) and show no visual
  difference — the `.tlg` changes are expected internal reordering, not
  regressions.  See `llmdoc/reference/latexpagediff-verification.md` for
  the verification workflow.
