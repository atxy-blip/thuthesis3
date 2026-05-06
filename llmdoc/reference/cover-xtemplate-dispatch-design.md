# Cover xtemplate Dispatch Design

This is a structural design sketch for mapping every `thuthesis2e` cover surface
onto the `thuthesis3` `xtemplate` implementation without rebuilding the old
tree of nested `if...else` switches.

Use this together with `llmdoc/reference/cover-structure-and-todo.md`.

## Goal

Make cover generation declarative:

- docstrip emits only the family-specific page instances and role registrations;
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
- degree type: `academic`, `professional`, `engineering`;
- thesis type: `thesis`, `proposal`;
- main language: `zh`, `en`;
- boolean surfaces: `true`, `false`.

The class/definition file should expose the current family as a docstrip-time
constant:

```tex
%<def-u>\tl_const:Nn \c__thu_cover_family_tl { u }
%<def-g>\tl_const:Nn \c__thu_cover_family_tl { g }
%<def-p>\tl_const:Nn \c__thu_cover_family_tl { p }
```

Runtime integers and booleans should map to slugs through generated names:

```tex
\tl_const:cn { c__thu_cover_type_1_tl  } { doctor }
\tl_const:cn { c__thu_cover_type_2_tl  } { master }
\tl_const:cn { c__thu_cover_dtype_1_tl } { academic }
\tl_const:cn { c__thu_cover_dtype_2_tl } { professional }
\tl_const:cn { c__thu_cover_dtype_3_tl } { engineering }

\cs_new:Npn \__thu_cover_type_slug:
  { \use:c { c__thu_cover_type_ \int_use:N \g__thu_info_type_int _tl } }
\cs_new:Npn \__thu_cover_dtype_slug:
  { \use:c { c__thu_cover_dtype_ \int_use:N \g__thu_info_dtype_int _tl } }
```

This still has conditionals at the validity/error boundary if needed, but the
normal dispatch path is name composition.

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

Keep old instance names such as `cover-u`, `cover-g`, and `cover-g-en` only as
temporary aliases or compatibility shims while migrating tests.

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

Graduate:

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
through composed names.

Example for graduate author label:

```tex
\tl_const:cn { c__thu_cover_label_g_author_academic_tl     } { 研究生 }
\tl_const:cn { c__thu_cover_label_g_author_professional_tl } { 申请人 }
\tl_const:cn { c__thu_cover_label_g_author_engineering_tl  } { 申请人 }

\cs_new:Npn \__thu_cover_label_g:n #1
  {
    \use:c
      {
        c__thu_cover_label_g_ #1 _
        \__thu_cover_dtype_slug: _tl
      }
  }
```

Example for English graduate page selection:

```tex
\@@_declare_page:nn { cover / g / titlepage-en / academic }
  { element = { title, degree, author, date }, ... }

\@@_declare_page:nn { cover / g / titlepage-en / professional }
  { element = { title, degree, author, field, date }, ... }

\__thu_cover_role_gset:nn { titlepage-en }
  { cover / g / titlepage-en / \__thu_cover_dtype_slug: }
```

This moves layout differences into page instances and text differences into
data names.

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

1. Add the registry helpers and no-op page/role.
2. Rename or alias current page instances to semantic names.
3. Replace the `\thu@titlepage` / `\thu@titlepage@en` aliases with role and
   sequence calls.
4. Move the hook body from direct `\UseInstance` calls to `maketitle` sequence
   calls.
5. Add postdoc command roles even before `cover / p / titlepage` is complete,
   so tests fail on layout/content rather than undefined commands.
6. Split `cover / g / titlepage-en` into academic/professional page instances.
7. Move graduate label differences into data lookup names.
8. Add `spine-auto` as a sequence selected by key-assigned slug.
9. Bring in `01-title-page-en` tests and expand enabled configs.

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
