# Versioning and `\changes` Policy

Use this policy when updating `CHANGELOG.md`, release versions, and
`\changes` entries in `source/thuthesis3.dtx`.

## Changelog Model

`CHANGELOG.md` is the release log for changes to the `thuthesis3` template
itself. It should combine the strongest parts of the local references:

- from upstream ThuThesis: Keep-a-Changelog structure, explicit issue links,
  and version comparison links after tags exist;
- from NJUThesis: Simplified Chinese prose, semantic-version framing, and
  concise categories.

Use these section names:

- `新增`
- `变动`
- `修复`
- `移除`
- `杂项`

Add `弃用` when a release deprecates public interfaces.

The main sections should describe template behavior, public interfaces, tests,
build/release behavior, and source architecture that affects the template.
Repository-management work such as `llmdoc/`, commit-style policy, branch
policy, or scratch-note hygiene should not be presented as template progress.
If it is recorded in `CHANGELOG.md`, put it under `杂项` and keep it brief.

Keep `[未发布]` at the top. Before the first release, record release-candidate
items there. After the first tag exists, add GitHub compare links at the bottom
of `CHANGELOG.md`.

## Versioning Model

Use semantic versioning for public release tags.

Recommended pre-1.0 interpretation:

- `v0.1.0`: first coherent alpha. It does not need to replace original
  ThuThesis, but it should install, compile a representative example, and show
  the core LaTeX3 architecture.
- `v0.2.0`, `v0.3.0`, ...: additional usable module milestones.
- `v1.0.0`: intended replacement-level release. Major original ThuThesis
  behavior should either be reproduced or documented as intentionally changed.

Do not tag `v0.1.0` merely because work has started. Tag it when a coherent
slice is usable and documented as alpha quality.

## What Belongs in `\changes`

`\changes` entries in `source/thuthesis3.dtx` are for changes to the template
source and user-facing manual. They are not a development diary and not a place
to document repository-management work.

Add a `\changes` entry for:

- public options, commands, environments, or setup keys;
- user-visible behavior changes;
- important compatibility fixes;
- major internal architecture that affects future maintenance;
- release-relevant module milestones.

Do not add a `\changes` entry for:

- every helper-function port;
- temporary migration experiments;
- pure llmdoc updates;
- branch-management policy;
- commit-message or changelog policy;
- changes to `.gitignore`, GitHub metadata, or repository-only docs;
- variable renames that have no user-facing or architectural significance.

Those details belong in Git commits, pull requests, `llmdoc/`, or temporary
investigation notes. If repository-maintenance work needs release visibility,
record it in `CHANGELOG.md` under `杂项`, not in `source/thuthesis3.dtx`
`\changes`.

## Language

Follow `llmdoc/reference/git-commit-style.md`:

- commit messages use Simplified Chinese;
- documentation prose in `source/thuthesis3.dtx` uses Simplified Chinese;
- `CHANGELOG.md` uses Simplified Chinese and should describe template changes
  first;
- TeX identifiers, option names, file names, and code identifiers stay as
  code.

## Initial `\changes` Draft

When adding the first change entries to `source/thuthesis3.dtx`, use release
milestone wording rather than progress-diary wording:

```tex
% \changes{v0.1.0}{2026/05/04}{开始以 \LaTeX3 接口重构 \cls{thuthesis}。}
```

Add later `v0.1.0` entries only when a coherent module lands, for example:

```tex
% \changes{v0.1.0}{2026/05/xx}{使用 \pkg{l3keys2e} 重构文档类选项。}
% \changes{v0.1.0}{2026/05/xx}{提供 \tn{thusetup} 的模块化键值设置接口。}
% \changes{v0.1.0}{2026/05/xx}{使用 \pkg{xtemplate} 重构封面页面对象。}
```

If a module is only proven in `../thuthesis2e/refactor/*` and not yet ported,
do not add it to `source/thuthesis3.dtx` `\changes`.
