# Reflection: Info Key Compatibility

## Context

While restoring grouped `info` keys in `thuthesis3`, the manual still contained
personal-information documentation copied from NJUThesis. That documentation
listed keys that are not part of the ThuThesis contract and missed several
legacy `thuthesis2e` keys.

## Lesson

For `\thusetup` personal information, use `../thuthesis2e/master` as the public
API and documentation source. Use NJUThesis only for implementation mechanics
such as `l3keys` grouping and forwarding.

The canonical implementation can be `thu / info`, but old unprefixed keys must
remain accepted through explicit top-level forwarding. Anonymous-mode filtering
must also be applied to both the grouped and unprefixed key surfaces.

## Promotion

Promoted stable guidance to `llmdoc/reference/setup-info-keys.md`.
