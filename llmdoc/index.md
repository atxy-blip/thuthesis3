# llmdoc Index

This tree records project memory for agents working on `thuthesis3`.

`thuthesis3` is the LaTeX3-native destination for the ThuThesis rewrite. Use
the sibling `../thuthesis2e` repository as the legacy behavior oracle and
`../NJUThesis-njulug` as the main local reference for the adopted LaTeX3
technology. Local directory names may differ from GitHub repository names; see
`reference/sibling-repositories.md` for canonical URLs.

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
- `reference/sibling-repositories.md`: local paths, canonical GitHub URLs,
  roles, and llmdoc locations for related repositories.
- `reference/latex3-patterns-from-njuthesis.md`: local LaTeX3 patterns to
  reuse or evaluate.
- `reference/git-commit-style.md`: commit subject labels, issue-reference
  suffixes, and language rules for commits and `.dtx` documentation.
- `reference/versioning-and-changes.md`: pre-1.0 versioning, changelog format,
  and when to add `\changes` entries.

## Memory

- `memory/decisions/2026-05-02-thuthesis3-as-destination.md`: decision that
  LaTeX3-native architecture lands here, not in `thuthesis2e/master`.
- `memory/reflections/README.md`: placeholder for future working reflections.
- `memory/reflections/2026-05-04-class-options.md`: reflection on class-option
  inheritance scope and documentation alignment.

Scratch investigations belong under `.llmdoc-tmp/`, not in this tree.
