# LaTeX3 Module Roadmap

This roadmap is for migration planning. It is not a strict implementation
schedule, but it gives future agents a default order that minimizes ambiguity.

## Phase 0: Oracle and Test Harness

Goal: make behavior measurable.

- Keep `../thuthesis2e/master` stable and original-compatible.
- Add missing regression tests there before large migration work.
- `testfiles/` now exists in this repository for setup-key compatibility and
  imported title-page fixtures. Keep adding local tests only when there is a
  concrete module to exercise.

## Phase 1: Options and Setup Interface

Goal: stabilize configuration before migrating layout behavior.

Candidate modules:

- class options under `thu / option`;
- `\thusetup` optional-argument forwarding;
- module keys such as `info`, `bib`, `image`, `abstract`, `theorem`, `math`,
  `header`, and `footer`;
- grouped key filtering for modes such as anonymous review or disabled feature
  packages.

Reference technology:

- `../NJUThesis-njulug/source/njuthesis.dtx` uses `l3keys2e`,
  `\keys_define:nn`, module forwarding, and filtered key groups.

Compatibility rule:

- For class options, inherit public option names from `../thuthesis2e/master`.
  Do not treat NJUThesis or `../thuthesis2e/refactor/*` branches as API
  sources; they may guide implementation mechanics only.
- For `\thusetup` personal-information keys, use `thu / info` as the canonical
  grouped key family while preserving every inherited unprefixed
  `../thuthesis2e/master` key through top-level aliases. Documentation text for
  those keys should come from ThuThesis, not NJUThesis.

## Phase 2: Data Model and Constants

Goal: separate stored thesis data from page rendering.

Candidate modules:

- thesis type and degree type;
- personal information and multilingual names;
- date formatting;
- anonymous-mode visibility rules;
- definition files for undergraduate, graduate, and postdoctoral constants.

## Phase 3: Page Objects and Cover Stack

Goal: make layout-sensitive pages declarative and testable.

Candidate modules:

- `xtemplate` element and page objects;
- title pages;
- copyright and statement pages;
- undergraduate, graduate, postdoctoral, and English variants.

This is a good area for proving behavior in `../thuthesis2e/refactor/*`, then
adapting the final design here.

## Phase 4: Document Phases and Hooks

Goal: replace ad hoc execution ordering with named phases.

Status: cover begin/body/end phases implemented (2026-05-04), with
`cover/back` added for declaration back matter (2026-05-06). Remaining
hook-based phases are still planned.

Candidate modules:

- ~~cover begin/body/end/back phases~~ (implemented);
- frontmatter and mainmatter transitions;
- delayed bibliography setup;
- PDF metadata and resource resolution;
- begin-document setup that must occur after package loading.

Reference technology:

- `../NJUThesis-njulug` has hook-based cover generation in recent source.

## Phase 5: Typography and Content Subsystems

Goal: migrate major behavior areas after configuration and phases are stable.

Candidate modules:

- font selection for Latin, CJK, and math fonts;
- page geometry, headers, and footers;
- chapter and contents formatting;
- bibliography and citation compatibility;
- footnotes, captions, lists, theorem environments, equation styles;
- abstracts, notation, acknowledgements, achievements, appendices, and spine.

## Default Rule

Do not port a large subsystem only by translating syntax. First identify the
behavior contract in `../thuthesis2e`, then choose the LaTeX3 representation
that should own the final design here.
