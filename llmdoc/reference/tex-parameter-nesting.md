# TeX Parameter Nesting Rules

When code-generating LaTeX3 commands or inline functions inside other commands
or inline functions, `#` must be doubled for each definition boundary the
parameter reference must survive.

## The Rule

```
# characters needed = 2^N, where N = nesting depth
```

| Depth | Context | Reference `#1` |
|-------|---------|---------------|
| 0 | Source file top level | `#1` |
| 1 | Inside one `\cs_new:Npn` / `\NewDocumentCommand` / `\clist_map_inline:nn` / etc. | `##1` |
| 2 | Inside two nested definitions | `####1` |
| 3 | Inside three nested definitions | `########1` |

## How TeX Reads `#`

TeX tokenizes `#` as category 6 (parameter). At each definition boundary,
`##` in the source is stored as a single `#` in the token list. When that
definition body is executed, the single `#` regains its parameter meaning.

## Common Pitfall: Three Levels

The most common error is underestimating depth when code-generating commands
with inline-function bodies:

```latex
% Level 0: outer map
\clist_map_inline:nn { chinese, english }
  {
    % Level 1: \NewDocumentCommand body
    \exp_args:Nc \NewDocumentCommand { thuset #1 }
      {
        % Level 2: inner map
        \clist_map_inline:nn {##1}
          { \use:c { \@@_ #1 _ ####1 : } }
        %                 ^    ^^^^
        %             Level 0  Level 2
      }
  }
```

`#1` = language name (level 0, source `#1`).
`##1` = `\NewDocumentCommand` optional argument (level 1, source `##1`).
`####1` = inner clist item (level 2, source `####1`).

## Mental Checklist

Before writing nested inline functions, count the definition boundaries:

1. How many `\..._map_inline:`, `\cs_new:Npn`, `\NewDocumentCommand`, etc.
   enclose this code?
2. Each boundary doubles the `#` count.
3. Verify by walking inward: start with `#1` at the innermost level, double
   for each boundary you cross to reach the source level.
