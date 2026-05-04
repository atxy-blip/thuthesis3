# Setup Info Keys

Use this reference when changing personal-information keys handled by
`\thusetup`.

## Public Contract

`thuthesis3` uses `thu / info` as the canonical LaTeX3 key family for personal
information. New examples and documentation should prefer grouped syntax:

```tex
\thusetup[info]{
  title  = {...},
  title* = {...},
}
```

For backward compatibility with `../thuthesis2e/master`, every inherited info
key must also work without the `info/` prefix:

```tex
\thusetup{
  title  = {...},
  title* = {...},
}
```

Implement this compatibility with narrow `.meta:nn` forwarding from top-level
`thu` keys to `thu / info`; do not move the canonical storage keys back to the
top level.

The `\thusetup` optional argument is normalized as a top-level `thu` key
assignment. Module forms such as `\thusetup[info]{...}` rely on the top-level
`info` module key to forward through the internal filtered setter; full paths
such as `\thusetup[info/title]{...}` are also passed as top-level nested keys.

## Source Of Truth

The inherited key names and user-facing descriptions come from
`../thuthesis2e/master`, especially its `封面信息`, abstract keyword, and spine
documentation sections. NJUThesis is only a technology reference for grouped
keys and module forwarding; it is not a source for ThuThesis personal-info key
names or descriptions.

Do not document NJUThesis-only keys such as `grade`, `major`, `field`,
`submit-date`, `defend-date`, `chairman`, `reviewer`, `supervisor-contact`, or
`school-code` unless they are intentionally added to the ThuThesis contract.

## Current Inherited Surface

The current compatibility set includes:

- thesis metadata: `title`, `title*`, `keywords`, `keywords*`;
- author metadata: `author`, `author*`, `student-id`;
- organization and degree metadata: `department`, `department*`,
  `degree-category`, `degree-category*`, `degree-name`, `degree-name*`,
  `discipline`, `discipline*`, `professional-field`,
  `professional-field*`, `engineering-field`, `engineering-field*`;
- supervisors: `supervisor`, `supervisor*`, `associate-supervisor`,
  `associate-supervisor*`, `co-supervisor`, `co-supervisor*`,
  `joint-supervisor`, `joint-supervisor*`;
- dates and secrecy: `date`, `start-date`, `end-date`, `secret-level`,
  `secret-year`;
- postdoctoral fields: `clc`, `udc`, `id`, `discipline-level-1`,
  `discipline-level-2`;
- spine fields: `include-spine`, `spine-title`, `spine-author`, `spine-font`.

## Anonymous Mode

Anonymous filtering must cover both the canonical grouped keys and the legacy
top-level aliases. When adding an anonymized info key, add the group marker to
both `thu / info` and `thu` so these two forms behave identically:

```tex
\thusetup[info]{author = {...}}
\thusetup{author = {...}}
```

Keep regression coverage for both surfaces. Current focused tests are:

- `testfiles/info-keys-compat.tex`;
- `testfiles/info-anonymous-compat.tex`.
