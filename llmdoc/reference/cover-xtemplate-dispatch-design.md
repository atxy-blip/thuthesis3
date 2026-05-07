# Cover xtemplate Dispatch Design

This is a structural design sketch for mapping every `thuthesis2e` cover surface
onto the `thuthesis3` `xtemplate` implementation without rebuilding the old
tree of nested `if...else` switches.

Use this together with `llmdoc/reference/cover-structure-and-todo.md`.

## Goal

Make cover generation declarative:

- docstrip emits only the family-specific page instances and role registrations;
- academic/professional differences are resolved at docstrip time through
  separate `.def` files (`def-g-aca` / `def-g-pro`), not through runtime
  conditionals;
- `xtemplate` owns element/page rendering;
- public commands resolve to named roles;
- roles resolve through generated control-sequence names;
- variant differences are encoded as data, aliases, element instances, or page
  instances, not as a long procedural dispatch.

The intended shape is:

```text
public command -> cover role -> cover sequence -> cover page instance(s)
                                      |
                                      +-> variant data resolved by csname
```

## Name Axes

Use short, stable slugs:

- family: `u`, `g`, `p`;
- page role: `titlepage`, `titlepage-en`, `postdoc-report`, `postdoc-title`,
  `spine`, `copyright`, `originality`;
- degree: `doctor`, `master`;
- degree type: `academic`, `professional` (used directly from
  `\g_@@_info_dtype_tl`, no longer mapped through an integer);
- thesis type: `thesis`, `proposal` (used as CS name suffix, e.g.,
  `\@@_g_cover_degree_thesis:`);
- main language: `zh`, `en`;
- boolean surfaces: `true`, `false`.

The class/definition file should expose the current family as a docstrip-time
constant:

```tex
%<def-u>\tl_const:Nn \c__thu_cover_family_tl { u }
%<def-g>\tl_const:Nn \c__thu_cover_family_tl { g }
%<def-p>\tl_const:Nn \c__thu_cover_family_tl { p }
```

Degree-type values are stored directly as a token list and used as string slugs
without integer mapping:

```tex
\tl_new:N  \g_@@_info_dtype_tl           % "academic" or "professional"
\keys_define:nn { thu / info }
  {
    degree-type .choices:nn = { academic, professional }
      { \tl_set:Nn \g_@@_info_dtype_tl {#1} },
    degree-type .initial:n  = academic,
  }
```

For the academic/professional split, prefer docstrip guards (`def-g-aca` /
`def-g-pro`) over runtime conditionals on `\g_@@_info_dtype_tl`.

## Instance Naming

Prefer semantic `xtemplate` instance names over historical macro names:

```text
cover / u / titlepage
cover / g / titlepage
cover / g / titlepage-en / academic
cover / g / titlepage-en / professional
cover / p / report
cover / p / titlepage
cover / spine
cover / copyright / u
cover / copyright / g
cover / originality / u
cover / originality / g
cover / originality / p
```

The current transitional names are shorter, but they should still be
family-first:

```text
cover-u
cover-g-zh
cover-g-en
cover-p-a
cover-p-b
```

Use `zh`/`en` when the axis is language, as with graduate covers. Use `a`/`b`
only when the axis is a fixed page slot, as with the two postdoc pages.

For postdoc pages, use `cover-p-a` and `cover-p-b`, not the reversed
`cover-a-p`/`cover-b-p`. The `p` records the family axis; `a` and `b` are only
the two postdoc page slots. Keep these short names only as temporary aliases or
compatibility shims while migrating tests toward semantic names such as
`cover / p / report` and `cover / p / titlepage`.

## Registry API

Create a small cover registry in the class layer. The registry stores role and
sequence expansions in generated control sequences.

Sketch:

```tex
\cs_new_protected:Npn \__thu_cover_role_gset:nn #1#2
  { \cs_gset:cpn { __thu_cover_role_ #1 : } {#2} }

\cs_new:Npn \__thu_cover_role:n #1
  { \use:c { __thu_cover_role_ #1 : } }

\cs_new_protected:Npn \__thu_cover_use_role:n #1
  { \exp_args:Nnx \UseInstance { thu } { \__thu_cover_role:n {#1} } }

\cs_new_protected:Npn \__thu_cover_sequence_gset:nn #1#2
  { \cs_gset:cpn { __thu_cover_sequence_ #1 : } {#2} }

\cs_new_protected:Npn \__thu_cover_sequence_use:n #1
  { \use:c { __thu_cover_sequence_ #1 : } }
```

The important constraint: public commands and hooks call roles/sequences; they
do not mention concrete page instances directly.

## Docstrip Role Registration

Each definition file registers the same public roles differently.

Bachelor:

```tex
%<def-u>\__thu_cover_role_gset:nn { titlepage }
%<def-u>  { cover / u / titlepage }
%<def-u>\__thu_cover_role_gset:nn { titlepage-en }
%<def-u>  { cover / noop }
```

Graduate academic (`def-g,def-g-aca`):

```tex
%<def-g>\__thu_cover_role_gset:nn { titlepage }
%<def-g>  { cover / g / titlepage }
%<def-g>\__thu_cover_role_gset:nn { titlepage-en }
%<def-g>  { cover / g / titlepage-en / \__thu_cover_dtype_slug: }
```

Graduate professional (`def-g,def-g-pro`):

```tex
%<def-g>\__thu_cover_role_gset:nn { titlepage }
%<def-g>  { cover / g / titlepage }
%<def-g>\__thu_cover_role_gset:nn { titlepage-en }
%<def-g>  { cover / g / titlepage-en / \__thu_cover_dtype_slug: }
```

Postdoc:

```tex
%<def-p>\__thu_cover_role_gset:nn { postdoc-report }
%<def-p>  { cover / p / report }
%<def-p>\__thu_cover_role_gset:nn { postdoc-title }
%<def-p>  { cover / p / titlepage }
```

Keep roles single-page. If a legacy command needs multiple pages, make that
legacy command call a sequence.

## Sequence Registration

Use sequences for command-level behavior. This preserves the old command
surfaces without nested switches.

```tex
%<def-u>\__thu_cover_sequence_gset:nn { titlepage }
%<def-u>  { \__thu_cover_use_role:n { titlepage } }

%<def-g>\__thu_cover_sequence_gset:nn { titlepage }
%<def-g>  { \__thu_cover_use_role:n { titlepage } }

%<def-p>\__thu_cover_sequence_gset:nn { titlepage }
%<def-p>  {
%<def-p>    \__thu_cover_use_role:n { postdoc-report }
%<def-p>    \cleardoublepage
%<def-p>    \__thu_cover_use_role:n { postdoc-title }
%<def-p>  }
```

For `\maketitle`, key the sequence by thesis type:

```tex
%<def-u>\__thu_cover_sequence_gset:nn { maketitle / thesis }
%<def-u>  {
%<def-u>    \__thu_cover_sequence_use:n { titlepage }
%<def-u>    \__thu_cover_spine_auto:
%<def-u>  }

%<def-g>\__thu_cover_sequence_gset:nn { maketitle / thesis }
%<def-g>  {
%<def-g>    \__thu_cover_sequence_use:n { titlepage }
%<def-g>    \__thu_cover_spine_auto:
%<def-g>    \cleardoublepage
%<def-g>    \__thu_cover_use_role:n { titlepage-en }
%<def-g>  }

%<def-g>\__thu_cover_sequence_gset:nn { maketitle / proposal }
%<def-g>  {
%<def-g>    \__thu_cover_sequence_use:n { titlepage }
%<def-g>    \__thu_cover_spine_auto:
%<def-g>  }

%<def-p>\__thu_cover_sequence_gset:nn { maketitle / thesis }
%<def-p>  { \__thu_cover_sequence_use:n { titlepage } }
```

Then `\maketitle` composes the sequence name:

```tex
\RenewDocumentCommand \maketitle { }
  {
    \hook_use:n { thuthesis3 / cover / begin }
    \exp_args:Nx \__thu_cover_sequence_use:n
      { maketitle / \__thu_cover_thesis_type_slug: }
    \hook_use:n { thuthesis3 / cover / end }
  }
```

This keeps the hook anchor, but removes the direct page list from the hook body.

## Optional Spine Without Flow Switches

The `include-spine` key can set a slug instead of requiring a runtime `if` in
`\maketitle`.

```tex
\tl_new:N \g__thu_cover_spine_slug_tl

\keys_define:nn { thu / info }
  {
    include-spine / true  .code:n =
      { \tl_gset:Nn \g__thu_cover_spine_slug_tl { true } },
    include-spine / false .code:n =
      { \tl_gset:Nn \g__thu_cover_spine_slug_tl { false } },
    include-spine         .initial:n = false
  }

\__thu_cover_sequence_gset:nn { spine-auto / true }
  { \__thu_cover_use_role:n { spine } }
\__thu_cover_sequence_gset:nn { spine-auto / false }
  { }

\cs_new_protected:Npn \__thu_cover_spine_auto:
  {
    \exp_args:Nx \__thu_cover_sequence_use:n
      { spine-auto / \g__thu_cover_spine_slug_tl }
  }
```

Sequences can call `\__thu_cover_spine_auto:`. The boolean decision is pushed
into key assignment and name lookup.

## Public Command Mapping

The legacy command surface maps cleanly:

```tex
\RenewDocumentCommand \maketitle { }
  { \__thu_cover_full_maketitle: }

\cs_new_protected:Npn \thu@titlepage
  { \__thu_cover_sequence_use:n { titlepage } }

\cs_new_protected:Npn \thu@titlepage@en
  { \__thu_cover_use_role:n { titlepage-en } }

\cs_new_protected:Npn \thu@cover@postdoc
  { \__thu_cover_use_role:n { postdoc-report } }

\cs_new_protected:Npn \thu@titlepage@postdoc
  { \__thu_cover_use_role:n { postdoc-title } }
```

This immediately fixes the current structural issue where `\thu@titlepage` and
`\thu@titlepage@en` both alias to full `\maketitle`.

## Variant Data Lookup

Within a shared page instance, avoid conditionals by resolving labels and text
through composed names. The `thuthesis3` implementation now uses three
mechanisms for variant resolution:

### 1. Docstrip guards for academic/professional

When an entire layout or label set differs between academic and professional
degree types, use docstrip guards to emit different code into
`thuthesis3-graduate-academic.def` and `thuthesis3-graduate-professional.def`:

```tex
%<def-g-aca>    \tl_const:cn { c_@@_name_author_tl } { 研究生 }
%<def-g-pro>    \tl_const:cn { c_@@_name_author_tl } { 申请人 }
```

This replaces the old `\@@_switch_name:` runtime dispatch.

### 2. `\@@_define_name_grad:nnn` for doctor/master

When a name constant differs between doctor (type=1) and master (type=2),
use the dedicated helper:

```tex
\cs_new_protected:Npn \@@_define_name_grad:nnn #1#2#3
  {
    \tl_const:ce { c_@@_name_ #1 _tl }
      { \int_compare:nTF { \g_@@_info_type_int = 2 } {#2} {#3} }
  }
```

Example: English supervisor label varies by degree level:

```tex
\@@_define_name_grad:nnn
  { supv a _en } { Thesis~ Supervisor } { Dissertation~ Supervisor }
```

### 3. `_thesis` / `_proposal` CS naming convention

Functions that differ between thesis and proposal covers carry a suffix:

```tex
\cs_new_protected:Npn \@@_g_cover_degree_thesis:   { ... }
\cs_new_protected:Npn \@@_g_cover_degree_proposal: { ... }
```

The element declaration selects the right variant:

```tex
content = \@@_g_cover_degree_thesis:,
```

When the proposal version is added, only the `content` key needs to change
(or be selected by a guard). This avoids `\bool_if:nTF` on
`\g_@@_opt_proposal_bool` inside the rendering function.

## Mapping Table

| `thuthesis2e` surface | `thuthesis3` role | Target instance or sequence |
| --- | --- | --- |
| `\maketitle`, bachelor | `maketitle / thesis` | `titlepage`, optional `spine` |
| `\maketitle`, graduate thesis | `maketitle / thesis` | `titlepage`, optional `spine`, `titlepage-en` |
| `\maketitle`, graduate proposal | `maketitle / proposal` | `titlepage`, optional `spine` |
| `\maketitle`, postdoc | `maketitle / thesis` | `postdoc-report`, `postdoc-title` |
| `\thu@titlepage`, bachelor | `titlepage` sequence | `cover / u / titlepage` |
| `\thu@titlepage`, graduate | `titlepage` sequence | `cover / g / titlepage` |
| `\thu@titlepage`, postdoc | `titlepage` sequence | `cover / p / report`, `cover / p / titlepage` |
| `\thu@titlepage@en` | `titlepage-en` role | `cover / g / titlepage-en / <dtype>` |
| `\thu@cover@postdoc` | `postdoc-report` role | `cover / p / report` |
| `\thu@titlepage@postdoc` | `postdoc-title` role | `cover / p / titlepage` |
| `\spine` | `spine` role | `cover / spine` or a dedicated command using the same page model |
| `\copyrightpage` | `copyright` role | `cover / copyright / <family>` or scan-file insertion |
| `\statement` | `originality` role | `cover / originality / <family>` or scan-file insertion |

## Implementation Order

1. [x] Add the registry helpers and no-op page/role.
2. [x] Rename or alias current page instances to semantic names.
3. [x] Replace the `\thu@titlepage` / `\thu@titlepage@en` aliases with role and
   sequence calls.
4. [x] Move the hook body from direct `\UseInstance` calls to `maketitle` sequence
   calls.
5. [x] Add postdoc command roles even before `cover / p / titlepage` is complete,
   so tests fail on layout/content rather than undefined commands.
6. [x] Split graduate academic/professional into separate `.def` files
   (`thuthesis3-graduate-academic.def` and
   `thuthesis3-graduate-professional.def`) with docstrip guards
   (`def-g-aca` / `def-g-pro`).
7. [x] Move graduate label differences into docstrip-guarded name constants and
   `\@@_define_name_grad:nnn` for doctor/master split.
8. [ ] Add `spine-auto` as a sequence selected by key-assigned slug.
9. [ ] Bring in `01-title-page-en` tests and expand enabled configs.

## Design Rules

- Do not put family dispatch inside `\maketitle`; docstrip registers the family.
- Do not put degree-type layout dispatch inside elements; select a page instance
  when the layout differs.
- Do not duplicate a page instance merely for text changes; use data lookup
  names for labels and words.
- Keep scan-file insertion as a role implementation detail for `copyright` and
  `originality`, not as a special case in the main cover flow.
- Treat missing generated names as implementation errors with clear messages.
  That is a validity check, not the normal dispatch mechanism.
