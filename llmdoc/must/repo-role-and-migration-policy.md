# Repository Role and Migration Policy

## Decision

`thuthesis3` is the final LaTeX3-native implementation repository. Do not make
it a line-by-line modernization of the old code unless that is the clearest
route for a specific module.

`../thuthesis2e` remains the original-compatible oracle and migration
laboratory. Its `master` branch should only receive changes that keep it a
clear legacy reference.

## Repository Roles

`../thuthesis2e/master`:

- preserves original ThuThesis behavior;
- carries the broad l3build regression suite;
- accepts tests, documentation, and behavior-preserving cleanup;
- should not become a half-modern transitional architecture.

`../thuthesis2e/refactor/*`:

- tests one cleanup or migration idea at a time;
- may temporarily use LaTeX3 internals to prove equivalence;
- should be disposable when the design has been ported.

`thuthesis3/main`:

- receives the final LaTeX3-native design;
- should prefer coherent modules over legacy file order;
- should document intentional behavior differences from the oracle.

`../NJUThesis-njulug`:

- provides the local technology reference for the adopted LaTeX3 patterns;
- is not a source of ThuThesis behavior.

Canonical GitHub URLs:

- upstream ThuThesis: <https://github.com/tuna/thuthesis>;
- `../thuthesis2e`: <https://github.com/atxy-blip/thuthesis2e>;
- `thuthesis3`: <https://github.com/atxy-blip/thuthesis3>;
- `../NJUThesis-njulug`: <https://github.com/nju-lug/NJUThesis>.

## Merge and Port Rules

Merge into `../thuthesis2e/master` only when the change is still a
behavior-preserving improvement of the original 2e codebase.

Copy or adapt into `thuthesis3` when the change is part of the new LaTeX3
architecture.

Examples that may merge into `../thuthesis2e/master`:

- add or correct regression tests;
- fix test fixtures;
- remove duplicated legacy code while preserving behavior;
- normalize legacy option defaults without changing user-visible behavior.

Examples that should usually be ported here instead:

- replacing option parsing with a new `l3keys` architecture;
- rebuilding cover construction around `xtemplate`;
- introducing hook-based frontmatter phases;
- rewriting a subsystem around a new LaTeX3 ontology.

## Working Interpretation

When in doubt, ask whether the branch is still "legacy ThuThesis, easier to
read" or "new architecture that reproduces old behavior." The first can belong
in `thuthesis2e/master`; the second belongs in `thuthesis3`.
