# Class Options

Use this reference when auditing or extending document-class options in
`source/thuthesis3.dtx`.

Class options are defined in the `thu / option` key family and processed via
`\ProcessKeysOptions { thu / option }`. This includes degree, language, output
mode, font, special-mode, scan-page, and optional-package-toggle keys (including
`minimal`).

The current source also exposes `language` and `main-language` as top-level
`\thusetup` aliases to the `option` key family. Treat that as transitional
implementation state. For the local language declaration design, see
`llmdoc/reference/language-interface.md`.

## Inheritance Rule

`thuthesis3` inherits class option names from `../thuthesis2e/master`.
It does not inherit the legacy implementation, file order, or internal
variables. Implementations should be LaTeX3-native and may differ whenever the
public option contract remains compatible.

Do not use `../thuthesis2e/refactor/*` branches as the class-option source of
truth. Those branches may contain experiments. Do not use NJUThesis as a
ThuThesis API source either; NJUThesis is only a technology reference for
patterns such as `l3keys2e`, key grouping, module forwarding, and delayed
setup.

## Audit Scope

When checking inherited class options:

- include option names accepted by `\documentclass[...]`;
- exclude legacy keys that are only intended for `\thusetup`;
- exclude math-style/math-symbol keys from the class-option audit unless the
  task explicitly targets math options;
- treat `font` and `cjk-font` as future font-loading work, not a small
  option-name-only task;
- accept `windows-font-dir` as the inherited public name for the local font
  path mechanism;
- do not require a user-facing `system` option when platform behavior is
  intentionally auto-detected internally;
- ignore extra NJUThesis-derived bootstrap options for legacy compatibility
  audits when they do not affect existing tests.

## Documentation and Source Order

Keep the public manual, variable declarations, and top-level class keys in the
same conceptual order. The current class-option documentation groups options as:

1. degree information;
2. language;
3. output and page mode;
4. special modes;
5. fonts;
6. scan-page paths and config files;
7. optional package toggles and minimal mode.

When adding an option, update the manual section, the variable declarations,
the key definition, `CHANGELOG.md`, and relevant `\changes` entries together
when the change is user-visible.
