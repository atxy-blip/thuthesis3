# Sibling Repositories

Local directory names are the names of the checked-out folders on this machine.
Canonical GitHub URLs identify the repository identity when the local name
differs.

## `../thuthesis2e`

Canonical GitHub repo: <https://github.com/atxy-blip/thuthesis2e>

Role:

- original-compatible ThuThesis fork;
- stable behavior oracle;
- broad l3build regression suite;
- laboratory for focused migration experiments.

Important docs:

- `../thuthesis2e/llmdoc/startup.md`
- `../thuthesis2e/llmdoc/must/repo-role-and-branch-policy.md`
- `../thuthesis2e/llmdoc/must/testing-oracle-policy.md`
- `../thuthesis2e/llmdoc/reference/l3build-tests.md`

Default use:

- add or improve behavior tests there first;
- run cleanup branches there when the result remains legacy-compatible;
- run migration experiment branches there when old behavior needs proof.

## `../NJUThesis-njulug`

Canonical GitHub repo: <https://github.com/nju-lug/NJUThesis>

Role:

- local technology reference for LaTeX3 patterns already adopted by the user;
- not a ThuThesis behavior oracle.

Important docs:

- `../NJUThesis-njulug/llmdoc/startup.md`
- `../NJUThesis-njulug/llmdoc/architecture/document-class-architecture.md`
- `../NJUThesis-njulug/llmdoc/reference/user-interface.md`
- `../NJUThesis-njulug/llmdoc/guides/common-development-tasks.md`
- `../NJUThesis-njulug/llmdoc/memory/decisions/2026-05-02-filtered-key-groups.md`

Default use:

- copy concepts, not behavior;
- adapt mechanisms to the ThuThesis public API and oracle tests;
- check recent decisions before modifying setup-key filtering.

## `thuthesis3`

Canonical GitHub repo: <https://github.com/atxy-blip/thuthesis3>

Role:

- current local repository;
- final LaTeX3-native destination for the ThuThesis rewrite;
- place to document final architecture and intentional behavior changes.

## Upstream ThuThesis

Canonical GitHub repo: <https://github.com/tuna/thuthesis>

Role:

- original upstream project;
- source of the legacy behavior that `../thuthesis2e` tracks and tests;
- not the place for experimental LaTeX3 architecture work.
