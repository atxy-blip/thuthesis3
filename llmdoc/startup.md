# Startup

Read this file first in every new session. It is the entry point into llmdoc.

## Immediate Reading

1. `llmdoc/must/repo-role-and-migration-policy.md` — which repository does what
2. `llmdoc/must/testing-and-oracle-policy.md` — how to prove behavior before porting
3. `llmdoc/architecture/source-and-build.md` — source layout, l3build, generated files
4. `llmdoc/architecture/latex3-module-roadmap.md` — module map and migration ordering
5. Task-specific files from the index

## Before Committing

- `llmdoc/reference/git-commit-style.md`
- `llmdoc/reference/versioning-and-changes.md`

## Repository Paths

Local clone paths are documented in `llmdoc/reference/sibling-repositories.md`.
Do not assume paths from repository names.

## Documentation Rule

Stable project memory belongs in `llmdoc/`. Temporary notes and investigations
belong in `.llmdoc-tmp/`.
