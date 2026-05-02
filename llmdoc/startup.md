# Startup

Read this file first when starting work in `thuthesis3`.

## Repository Role

`thuthesis3` is the destination repository for a LaTeX3-native rewrite of
ThuThesis. It is not the behavior oracle. The sibling `../thuthesis2e`
repository keeps the original-compatible 2e implementation and its l3build
regression suite.

Use this repository for:

- final LaTeX3-native implementation;
- module structure and public architecture;
- adapted code and tests after behavior has been proven against the legacy
  oracle;
- documenting intentional behavior differences from original ThuThesis.

## Required Reading

Before non-trivial edits, read:

1. `llmdoc/must/repo-role-and-migration-policy.md`
2. `llmdoc/must/testing-and-oracle-policy.md`
3. `llmdoc/architecture/source-and-build.md`
4. `llmdoc/architecture/latex3-module-roadmap.md`
5. `llmdoc/reference/git-commit-style.md` before drafting commits or changing
   public `.dtx` documentation
6. the relevant guide or reference file for the task

## Sibling Repositories

- `../thuthesis2e`: stable legacy oracle and migration laboratory.
  Canonical GitHub repo: <https://github.com/atxy-blip/thuthesis2e>.
- `../NJUThesis-njulug`: local LaTeX3 technology reference, especially for
  `l3keys`, `xtemplate`, hook-based phases, setup modules, and l3build usage.
  Canonical GitHub repo: <https://github.com/nju-lug/NJUThesis>.
- `thuthesis3`: current local repository and final LaTeX3 destination.
  Canonical GitHub repo: <https://github.com/atxy-blip/thuthesis3>.
- Upstream ThuThesis: original behavior source at
  <https://github.com/tuna/thuthesis>.

## Default Working Rule

Classify the work before editing:

- Behavior-preserving legacy cleanup belongs in `../thuthesis2e` first.
- LaTeX3-native design belongs in `thuthesis3`.
- Migration experiments may be proven in `../thuthesis2e/refactor/*`, then
  copied or adapted here.
- New tests discovered during experiments should usually be added to
  `../thuthesis2e/master` first, then ported here when the module exists.

## Documentation Rule

Stable project memory belongs in `llmdoc/`. Temporary notes and investigations
belong in `.llmdoc-tmp/`.
