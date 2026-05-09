# llmdoc Index

Directory of project documentation — use this to find the right file for your
task.

## Startup

- `startup.md`: first file to read in a new session.

## Must Read

- `must/repo-role-and-migration-policy.md`: role of this repository and how it
  relates to `thuthesis2e` and `NJUThesis-njulug`.
- `must/testing-and-oracle-policy.md`: how to prove behavior before porting or
  accepting LaTeX3 modules.

## Overview

- `overview/project-overview.md`: current repository purpose, top-level files,
  and known status.

## Architecture

- `architecture/source-and-build.md`: source layout, l3build configuration, and
  generated files.
- `architecture/latex3-module-roadmap.md`: migration module map and recommended
  ordering for LaTeX3 feature work.

## Guides

- `guides/module-migration-workflow.md`: practical workflow for testing a
  module in `thuthesis2e` and adapting it into `thuthesis3`.

## Reference

- `reference/class-options.md`: class-option inheritance rules, audit scope,
  and documentation/source ordering.
- `reference/cover-structure-and-todo.md`: cover-page structure in
  `thuthesis2e` and `thuthesis3`, variant counts, gaps, and TODO list.
- `reference/cover-xtemplate-dispatch-design.md`: proposed docstrip,
  `xtemplate`, and generated-control-sequence cover dispatch architecture.
- `reference/setup-info-keys.md`: `\thusetup` personal-info key inheritance,
  grouped `info` syntax, legacy unprefixed compatibility, and anonymous-mode
  filtering rules.
- `reference/sibling-repositories.md`: local paths, canonical GitHub URLs,
  roles, and llmdoc locations for related repositories.
- `reference/latex3-patterns-from-njuthesis.md`: local LaTeX3 patterns to
  reuse or evaluate.
- `reference/git-commit-style.md`: commit subject labels, issue-reference
  suffixes, and language rules for commits and `.dtx` documentation.
- `reference/versioning-and-changes.md`: pre-1.0 versioning, changelog format,
  and when to add `\changes` entries.
- `reference/latexpagediff-verification.md`: visual-equivalence verification
  when l3build `.tlg` tests fail after internal reordering.
- `reference/l3build-tests.md`: current local test layout, active l3build
  configs, and `.tlg` regeneration guidance.

## Memory

- `memory/decisions/2026-05-02-thuthesis3-as-destination.md`: decision that
  LaTeX3-native architecture lands here, not in `thuthesis2e/master`.
- `memory/decisions/2026-05-06-pdf-only-verification.md`: decision that during
  rapid template development, skip `l3build check` and verify only via PDF
  visual comparison.
- `memory/reflections/README.md`: placeholder for future working reflections.
- `memory/reflections/2026-05-04-class-options.md`: reflection on class-option
  inheritance scope and documentation alignment.
- `memory/reflections/2026-05-04-info-key-compatibility.md`: reflection on
  grouped `info` keys, legacy aliases, and avoiding NJUThesis-only docs.
- `memory/reflections/2026-05-04-cover-hooks.md`: reflection on hook-based cover
  generation with begin/body/end/back phases, rule-ordered labels, and
  one-time `enddocument` back-cover scheduling.
- `memory/reflections/2026-05-07-cover-info-block.md`: reflection on the
  graduate cover info block refactor, storage-aware row generation, reusable
  vertical box centering, and PDF-only verification notes.
- `memory/reflections/2026-05-07-cover-en-title.md`: reflection on the
  graduate English cover title/supervisor box alignment fixes, rejected
  template extensions, and the no-`comp.pdf` regeneration boundary.
- `memory/reflections/2026-05-08-proposal-cover.md`: reflection on the
  graduate proposal cover implementation, the pivot from `_thesis`/`_proposal`
  CS naming to bool dispatch, and the English cover name-token split.
- `memory/reflections/2026-05-08-undergraduate-cover.md`: reflection on the
  undergraduate cover layout update, shared supervisor formatting helpers,
  two-logo system, and dynamic secret rendering.
- `memory/reflections/2026-05-09-undergraduate-cover-spacing.md`: reflection on
  undergraduate cover spacing refinements, `top-anchor` mechanism, `thulogo`
  rename, title box construction with `\prevdepth` compensation, info fill
  interim, and `include_graphics` promotion to class-level.
- `memory/reflections/2026-05-09-undergraduate-cover-info-fork.md`: reflection on
  forking the graduate info-drawing mechanism to undergraduate, docstrip-split
  supervisor formatting helpers, old `\@@_cover_info:` removal, and the
  merge path for unifying the two parameterized info systems.
- `memory/doc-gaps.md`: tracked gaps between the codebase and llmdoc
  reference pages.

Scratch investigations belong under `.llmdoc-tmp/`, not in this tree.
