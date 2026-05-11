# Reflection: TeX Parameter Nesting Incident

Date: 2026-05-10

## Trigger

While generating `\thusetchinese` and `\thusetenglish`, a nested
`\clist_map_inline:nn` inside a generated `\NewDocumentCommand` produced an
"illegal parameter number" error.

## Outcome

The bug was an under-doubled parameter token in the inner inline function:
`###1` needed to be `####1`.

The durable rule is documented in `llmdoc/reference/tex-parameter-nesting.md`.
Do not duplicate that rule here; keep this reflection as the incident record.

## Follow-up

When editing generated commands with nested inline functions, consult
`llmdoc/reference/tex-parameter-nesting.md` before changing `#` counts.
