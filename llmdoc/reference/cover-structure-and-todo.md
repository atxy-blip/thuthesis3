# Cover Structure and TODO

This note organizes cover-related behavior from `../thuthesis2e` and the
current `thuthesis3` implementation, as inspected on 2026-05-06 and updated
for local cover-helper organization on 2026-05-08.

Use `../thuthesis2e/master` as the behavior oracle. Use this file to keep the
LaTeX3 cover migration focused on reusable structure, variant counts, and gaps.
For the proposed docstrip/`xtemplate` dispatch architecture, see
`llmdoc/reference/cover-xtemplate-dispatch-design.md`.

## thuthesis2e Cover Structure

Primary implementation file: `../thuthesis2e/thuthesis.dtx`.

Main flow:

- `\maketitle` clears the page, switches to `Alph` numbering, bookmarks the
  title, calls `\thu@titlepage`, optionally calls `\spine`, and for graduate
  thesis documents appends `\thu@titlepage@en`.
- `\thu@titlepage` dispatches by degree:
  - graduate -> `\thu@titlepage@thesis`;
  - bachelor -> `\thu@titlepage@bachelor`;
  - postdoc -> `\thu@cover@postdoc`, clear double page,
    `\thu@titlepage@postdoc`.
- `\copyrightpage` is a separate public page command for bachelor and graduate
  documents. It supports generated pages and scan-file replacement.
- `\statement` is a separate public page command for bachelor and graduate
  originality statements. It supports generated pages, scan-file replacement,
  and `page-style`.
- `\spine` is a separate public page command and is optionally called by
  `\maketitle` when `include-spine` is true.

Reusable implementation pieces:

- dispatch by document family and degree-type belongs outside low-level page
  drawing;
- graduate Chinese cover can share one page body and vary labels, degree text,
  title size, info rows, and proposal/student-id handling;
- graduate English cover shares title, degree sentence, supervisor table, and
  date helpers, with separate academic/professional vertical layout;
- bachelor cover shares secret mark, logo/name image, thesis label, title,
  information table, and date pieces;
- postdoc cover is two independent pages: a report cover and a title page;
- common box helpers (`stretch`, `pad`, underline, date formatting, name/title
  splitting) are the reusable behavior contract, even if their implementation
  should be rewritten in LaTeX3 style.

## thuthesis2e Cover Kinds

Counting concrete cover/title-page primitives, `thuthesis2e` has five main
page kinds plus one optional spine page:

1. Bachelor Chinese cover: `\thu@titlepage@bachelor`.
2. Graduate Chinese cover/proposal cover: `\thu@titlepage@thesis`.
3. Graduate English cover: `\thu@titlepage@en`, with academic and professional
   sublayouts.
4. Postdoc report cover: `\thu@cover@postdoc`.
5. Postdoc title page: `\thu@titlepage@postdoc`.
6. Optional spine: `\spine`.

Related but separate front/back matter pages:

- bachelor copyright page;
- graduate copyright page;
- bachelor statement page;
- graduate statement page.

Current oracle test coverage in `../thuthesis2e`:

- `testfiles/01-title-page/`: 29 fixtures:
  - 3 bachelor;
  - 10 doctor Chinese-cover cases;
  - 2 doctor English-cover cases;
  - 8 master Chinese-cover cases;
  - 3 master English-cover cases;
  - 2 postdoc page cases;
  - 1 proposal cover case.
- `testfiles/01-title-page-en/`: 30 fixtures:
  - 15 English-main Chinese-cover cases, covering academic/professional
    doctor/master and professional engineering master variants;
  - 15 isolated English-cover cases for the same variant matrix.

Important differences inside the graduate family:

- `degree = doctor` versus `degree = master` changes English `Dissertation` /
  `Thesis`, supervisor wording, and degree text.
- `degree-type = academic` shows discipline and uses "研究生"; professional
  variants use applicant-oriented labels and professional field information.
- engineering master is a special professional-master flavor with its own
  Chinese label behavior.
- `thesis-type = proposal` uses the graduate Chinese cover body but changes the
  degree/category text and requires `student-id`.
- `language = english` still has a Chinese cover, but the Chinese cover includes
  the English title beneath the Chinese title.
- secret information affects the graduate and bachelor cover top area.

## thuthesis3 Cover Structure

Primary implementation file: `source/thuthesis3.dtx`.

Current reusable architecture:

- `xtemplate` object type `thu`;
- generic `element` template with `content`, `format`, `bottom-skip`, and
  `align`;
- generic `page` template with `element`, `prefix`, `geometry`, `format`,
  `top-anchor`, `top-skip`, `bottom-skip`, bookmark fields, and page-level
  rendering;
- declarative page instances:
  - `cover-u`;
  - `cover-g-zh`;
  - `cover-g-en`;
  - `cover-p-a`;
  - `cover-p-b`;
  - `copyright`;
  - `originality`;
- cover execution hooks:
  - `thuthesis3/cover/begin`;
  - `thuthesis3/cover/body`;
  - `thuthesis3/cover/end`;
  - `thuthesis3/cover/back`.

### Page template `top-anchor` key

The `top-anchor` key (`null` / `none`, default `null`) controls whether the
generic page template inserts an empty `\hbox:n{}` before applying `top-skip`:

- `null`: inserts `\hbox:n{}` → reproduces legacy `\null\vskip` behavior; used
  by graduate and postdoc cover pages.
- `none`: no anchor box → the page starts directly from the first element;
  used by `cover-u`.

Graduate covers need the `\null` anchor because the legacy `thuthesis2e` code
starts with `\null\vskip 8.1pt`, and a rule-based `\vspace*` substitute would
change the baseline glue and shift the entire title/degree block. Undergraduate
covers start from a `\parbox[t][0cm][t]{\textwidth}{...}` secret box whose
top edge is the page reference point, so no anchor is needed.

### Docstrip-based academic/professional separation

The graduate definition file is now split into two docstrip targets:

- `thuthesis3-graduate-academic.def` (guards `def-g,def-g-aca`);
- `thuthesis3-graduate-professional.def` (guards `def-g,def-g-pro`).

The shared graduate code uses only `def-g` guards. Academic-only code uses
`def-g-aca`; professional-only code uses `def-g-pro`. This eliminates the
previous runtime `\@@_switch_name:` function and the `\int_compare:nTF`
conditionals in `\@@_g_cover_info:` and English supervisor names, and
`\@@_cover_title_zihao:`.

Design rules for the split:

- Put a name constant or code block under `def-g` when it is identical for
  both academic and professional;
- Put it under `def-g-aca` or `def-g-pro` when the two degree types differ;
- Prefer docstrip-time separation over runtime `\int_compare:nTF` on
  `\g_@@_info_dtype_tl`.

### Name resolution helpers

`\@@_define_name_grad:nnn` (`source/thuthesis3.dtx`) resolves doctor/master
name differences:

```tex
\@@_define_name_grad:nnn {<name>} {<master value>} {<doctor value>}
```

It uses `\int_compare:nTF { \g_@@_info_type_int = 2 }` internally (type=1 is
doctor, type=2 is master). For example, the English supervisor label:

```tex
\@@_define_name_grad:nnn
  { supv a _en } { Thesis~ Supervisor } { Dissertation~ Supervisor }
```

This keeps the doctor/master difference local to the name definition rather
than spreading it through the rendering code.

### Thesis/proposal dispatch with `\@@_g_cover_degree:`

A single function `\@@_g_cover_degree:` handles both thesis and proposal
degree/category text. It uses `\bool_if:NTF \g_@@_opt_proposal_bool` for internal
dispatch:

- Thesis branch: `apply begin` + degree category + `pro degree` + `apply end`
  (composes the degree-application sentence from name tokens).
- Proposal branch: `thu` + degree type name (from `\c_@@_name_type_clist`)
  + `proposal` (composes the report-type identifier from name tokens).

Both branches are wrapped in `\@@_parens:n`, which provides parentheses via the
`paren l` and `paren r` name tokens. The `apply begin`/`apply end` tokens no
longer carry literal parentheses — the `\@@_parens:n` helper owns the paren
insertion.

The `cover/back` hook is the semantic home for 封底/back-cover declaration
material. `decl-b` is registered there. `\maketitle` links it to the dedicated
`enddocument` hook by adding one next-code chunk that executes
`\hook_use_once:n { thuthesis3 / cover / back }`. This follows the `lthooks`
one-time hook model: if `\maketitle` is never called, the back-cover hook is not
scheduled; if `\maketitle` is called more than once, `cover/back` still executes
only once.

Counting declared cover/title-page instances, `thuthesis3` currently has five
main page kinds plus two declaration/authorization page instances:

1. Bachelor cover instance: `cover-u`.
2. Graduate Chinese cover instance: `cover-g-zh`.
3. Graduate English cover instance: `cover-g-en`.
4. Postdoc report cover instance: `cover-p-a`.
5. Postdoc title-page placeholder: `cover-p-b`.
6. Copyright page instance: `copyright`.
7. Originality statement instance: `originality`.

`testfiles/config-title-page.lua` now includes `01-title-page-proposal` in the
active test list (graduated from smoke subset).

Current local title-page fixtures in `thuthesis3` mirror only
`../thuthesis2e/testfiles/01-title-page/`:

- 29 imported fixtures total;
- no imported `01-title-page-en/` fixture tree yet;
- `testfiles/config-title-page.lua` runs a growing selection beyond the original
  smoke subset (currently 8 fixtures including bachelor, doctor, master, and
  proposal variants);

Current short instance names follow a family-first convention:

| Family | Instance names | Meaning |
| --- | --- | --- |
| Undergraduate | `cover-u` | Undergraduate Chinese cover. |
| Graduate | `cover-g-zh`, `cover-g-en` | Graduate Chinese/proposal cover and graduate English cover. |
| Postdoctoral | `cover-p-a`, `cover-p-b` | Postdoc report cover and postdoc title page. The `p` marks the postdoc family; `a`/`b` keeps the upstream page-slot order from `p / cover-a /` and `p / cover-b /`. |

Avoid the older reversed spelling `cover-a-p`/`cover-b-p`: it hides the family
axis and makes the postdoc pair look less related to the rest of the cover
taxonomy. Also avoid `cover-g-a`/`cover-g-b` for graduate pages: the graduate
split is a language split, so `cover-g-zh`/`cover-g-en` records more meaning
than an ordered pair.

### Cover helper locality

Cover-specific helper functions live next to the element or page instances that
call them in `source/thuthesis3.dtx`, rather than in the earlier generic helper
section. Treat this as an organization rule for layout contracts: helpers for
`g / cover-zh / ...` stay with the graduate Chinese cover instances, and helpers
for `g / cover-en / ...` stay with the graduate English cover instances. Keep
only genuinely shared box, name, date, and setup utilities in the generic helper
area.

This locality makes the `xtemplate` instance body and its private formatting
helpers readable as one unit. It is especially useful for cover parity work,
where a helper often encodes one legacy page metric and is not a reusable
document-wide primitive.

### Supervisor formatting helpers

`\@@_cover_format_name:n` and `\@@_cover_format_title:n` (`source/thuthesis3.dtx`)
are class-level helpers with docstrip-split implementations for undergraduate
and graduate:

| Helper | `def-u` | `def-g` |
|--------|---------|---------|
| `\@@_cover_format_name:n` | `4em` stretch + `1.5em` gap | `3cm` pad + `4em` stretch |
| `\@@_cover_format_title:n` | `2.5em` stretch | `3em` stretch |

`\@@_cover_format_supv:NNNn` / `\@@_cover_format_supv:n`: pop a supervisor
clist, extract name and title tokens, and format them through the per-family
name/title helpers. These live under the `class` guard and are genuinely shared.

These were originally graduate-only (`\@@_g_cover_format_*`) and were initially
promoted to class-level with a single shared implementation. They were later
split by docstrip guard when undergraduate was found to need different spacing
parameters than graduate. Graduate call sites (`\@@_g_cover_author_row:NN`,
`\@@_g_cover_supv_row:NNn`) use the shared names, as do the undergraduate
counterparts (`\@@_u_cover_author_row:NN`, `\@@_u_cover_supv_row:NNn`).

### Undergraduate info-system fork

The undergraduate cover info section (`\@@_u_cover_info:*`) was forked from the
graduate Chinese cover info system (`\@@_g_cover_info:*`). Both share the same
architectural decomposition:

1. `_info:` → `_info_box:` (fixed-height box wrapper)
2. `_info_body:NN` → left indent + `_info_table:NN`
3. `_info_dims:NN` → strut height/depth = `0.7/0.3` of `\baselineskip`
4. `_info_table:NN` → `\@@_box_vcenter:n { items }`
5. Item generators: `info_item` (maps `\c_@@_name_coveritem_clist`),
   `author_item`, `stuid_item` (conditional on `\g_@@_opt_proposal_bool`),
   `supv_item` (maps `a, b, c`)
6. `_info_row:NNnn` → shared row geometry (`label → colon → value → 6pt`)
7. Three value-formatting paths: `_info_row:NNn` (plain `\@@_info:n`),
   `_author_row:NN` (`\@@_cover_format_name:V`),
   `_supv_row:NNn` (`\@@_cover_format_supv:n`)

The undergraduate variant differs from graduate only in:
- Left indent: `81bp + 6pt` vs `83bp + 6pt`
- Label width: `2.5cm` (no supvc) / `86bp` (with supvc) vs graduate's
  `2.85cm`/`2.75cm` label/colon layout
- `\@@_cover_format_name:n` / `\@@_cover_format_title:n` docstrip variants
- Info element format: `\@@_fontsize:nn { 16 bp }{ 30.96 bp }` vs graduate's
  `\@@_fontsize:nn { 15.04 bp }{ 31.2 bp }`

The old generic `\@@_cover_info:` (which used `\clist_map_inline:Nn` with
`\@@_get_max_info_width:NN`) and its helpers (`\@@_cover_info_aux:NN`,
`\@@_cover_info_aux:N`) were removed — no call site uses them after both
undergraduate and graduate have dedicated info systems.

### Shared graphics helper

`\@@_include_graphics:nn` and its `nV` variant (`source/thuthesis3.dtx`) are
class-level shared helpers wrapping `\includegraphics[width=#1]{#2}`. Originally
defined in the undergraduate-only (`def-u`) section, they were promoted to the
generic helper area when the two-logo system needed the `nV` variant for file
name token-list expansion. They are used by `\@@_u_cover_thulogo:` and available
for future cover graphics.

## Local Title-Page Fixture Mapping

The imported `testfiles/01-title-page/*.tex` files are best understood as a
cover-category matrix. Each fixture varies only the class options and
`\thusetup` keys needed to exercise an isolated cover instance. This table records
the current local inputs, not the desired final behavior.

| Fixture | Cover category | Instance surface | Class options | Input keys / variation |
| --- | --- | --- | --- | --- |
| `01-title-page-bachelor.tex` | Bachelor Chinese cover | `\UseInstance{thu}{cover-u}` | `degree=bachelor` | Baseline bachelor keys: `title`, `department`, `discipline`, `author`, `supervisor`, `date`. Current local file calls the page instance directly. |
| `01-title-page-bachelor-secret.tex` | Bachelor Chinese cover, secret mark | `\UseInstance{thu}{cover-u}` | `degree=bachelor` | Baseline bachelor keys plus `secret-level`, `secret-year`. |
| `01-title-page-bachelor-en.tex` | Bachelor Chinese cover, English-main input | `\UseInstance{thu}{cover-u}` | `degree=bachelor` | Baseline bachelor keys plus `language`, `title*`; exercises the Chinese cover when main language is English. |
| `01-title-page-doctor-1-1.tex` | Graduate Chinese cover, doctor academic baseline | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor` | `title`, `degree-category`, `department`, `discipline`, `author`, `supervisor`, `date`. |
| `01-title-page-doctor-1-2.tex` | Graduate Chinese cover, doctor academic associate supervisor | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor` | Doctor academic baseline plus `associate-supervisor`. |
| `01-title-page-doctor-1-3.tex` | Graduate Chinese cover, doctor academic title wrapping variant | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor` | Same key set as doctor-1-1; input values vary title length/wrapping. |
| `01-title-page-doctor-1-4.tex` | Graduate Chinese cover, doctor academic title plus associate supervisor variant | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor` | Same key set as doctor-1-2; input values vary title length/wrapping. |
| `01-title-page-doctor-1-5.tex` | Graduate Chinese cover, doctor academic secret mark | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor` | Doctor academic baseline plus `secret-level`, `secret-year`. |
| `01-title-page-doctor-1-6.tex` | Graduate Chinese cover, doctor academic co-supervisor | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor` | Doctor academic baseline plus `co-supervisor`. |
| `01-title-page-doctor-1-7.tex` | Graduate Chinese cover, doctor professional baseline | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor, degree-type=professional` | Professional doctor keys omit `discipline`: `title`, `degree-category`, `department`, `author`, `supervisor`, `date`. |
| `01-title-page-doctor-1-8.tex` | Graduate Chinese cover, doctor professional secret mark | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor, degree-type=professional` | Doctor professional baseline plus `secret-level`, `secret-year`. |
| `01-title-page-doctor-1-9.tex` | Graduate Chinese cover, doctor professional co-supervisor | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor, degree-type=professional` | Doctor professional baseline plus `co-supervisor`. |
| `01-title-page-doctor-1-10.tex` | Graduate Chinese cover, doctor professional co-supervisor and secret mark | `\UseInstance{thu}{cover-g-zh}` | `degree=doctor, degree-type=professional` | Doctor professional baseline plus `co-supervisor`, `secret-level`, `secret-year`. |
| `01-title-page-doctor-2-1.tex` | Graduate English cover, doctor academic | `\UseInstance{thu}{cover-g-en}` | `degree=doctor` | English starred keys: `title*`, `degree-category*`, `discipline*`, `author*`, `supervisor*`, `associate-supervisor*`, plus `date`. |
| `01-title-page-doctor-2-2.tex` | Graduate English cover, doctor professional | `\UseInstance{thu}{cover-g-en}` | `degree=doctor, degree-type=professional` | English starred keys omit `discipline*`: `title*`, `degree-category*`, `author*`, `supervisor*`, `associate-supervisor*`, plus `date`. |
| `01-title-page-master-1-1.tex` | Graduate Chinese cover, master academic baseline | `\UseInstance{thu}{cover-g-zh}` | `degree=master` | `title`, `degree-category`, `department`, `discipline`, `author`, `supervisor`, `co-supervisor`, `date`. |
| `01-title-page-master-1-2.tex` | Graduate Chinese cover, master academic secret mark | `\UseInstance{thu}{cover-g-zh}` | `degree=master` | Master academic baseline plus `secret-level`, `secret-year`. |
| `01-title-page-master-1-3.tex` | Graduate Chinese cover, master professional baseline | `\UseInstance{thu}{cover-g-zh}` | `degree=master, degree-type=professional` | Professional master keys omit `discipline`: `title`, `degree-category`, `department`, `author`, `supervisor`, `co-supervisor`, `date`. |
| `01-title-page-master-1-4.tex` | Graduate Chinese cover, master professional secret mark | `\UseInstance{thu}{cover-g-zh}` | `degree=master, degree-type=professional` | Master professional baseline plus `secret-level`, `secret-year`. |
| `01-title-page-master-1-5.tex` | Graduate Chinese cover, master professional field | `\UseInstance{thu}{cover-g-zh}` | `degree=master, degree-type=professional` | Master professional baseline plus `professional-field`. |
| `01-title-page-master-1-6.tex` | Graduate Chinese cover, master professional field and secret mark | `\UseInstance{thu}{cover-g-zh}` | `degree=master, degree-type=professional` | Master professional baseline plus `professional-field`, `secret-level`, `secret-year`. |
| `01-title-page-master-1-7.tex` | Graduate Chinese cover, engineering master field | `\UseInstance{thu}{cover-g-zh}` | `degree=master, degree-type=professional` | Master professional baseline plus `engineering-field`; exercises engineering-master label behavior. |
| `01-title-page-master-1-8.tex` | Graduate Chinese cover, engineering master secret mark | `\UseInstance{thu}{cover-g-zh}` | `degree=master, degree-type=professional` | Master professional baseline plus `engineering-field`, `secret-level`; notably no `secret-year` key in this fixture. |
| `01-title-page-master-2-1.tex` | Graduate English cover, master academic | `\UseInstance{thu}{cover-g-en}` | `degree=master` | English starred keys: `title*`, `degree-category*`, `discipline*`, `author*`, `supervisor*`, `associate-supervisor*`, plus `date`. |
| `01-title-page-master-2-2.tex` | Graduate English cover, master professional | `\UseInstance{thu}{cover-g-en}` | `degree=master, degree-type=professional` | English starred keys omit `discipline*`: `title*`, `degree-category*`, `author*`, `supervisor*`, `associate-supervisor*`, plus `date`. |
| `01-title-page-master-2-3.tex` | Graduate English cover, master professional field | `\UseInstance{thu}{cover-g-en}` | `degree=master, degree-type=professional` | Master professional English keys plus `professional-field*`. |
| `01-title-page-postdoc-1.tex` | Postdoc report cover | `\UseInstance{thu}{cover-p-a}` | `degree=postdoc` | `title`, `author`, `date`, `start-date`, `end-date`. |
| `01-title-page-postdoc-2.tex` | Postdoc title page placeholder | `\UseInstance{thu}{cover-p-b}` | `degree=postdoc` | `title`, `title*`, `author`, `discipline-level-1`, `discipline-level-2`, `date`, `start-date`, `end-date`. The target instance exists as an empty placeholder. |
| `01-title-page-proposal.tex` | Graduate Chinese proposal cover | `\UseInstance{thu}{cover-g-zh}` | `thesis-type=proposal, degree=doctor` | Proposal keys: `title`, `department`, `discipline`, `author`, `student-id`, `supervisor`, `associate-supervisor`, `date`; no `degree-category`. |

Category-to-instance mapping implied by these fixtures:

| Category | Instance surface in fixtures | Current `thuthesis3` instance target | Main axes exercised |
| --- | --- | --- | --- |
| Bachelor Chinese cover | `\UseInstance{thu}{cover-u}` | `cover-u` | `language`, `title*`, `secret-level`, `secret-year`. |
| Graduate Chinese cover | `\UseInstance{thu}{cover-g-zh}` | `cover-g-zh` | `degree`, `degree-type`, `thesis-type`, `discipline` versus professional field keys, supervisor variants, secret keys. |
| Graduate English cover | `\UseInstance{thu}{cover-g-en}` | `cover-g-en` | `degree`, `degree-type`, `discipline*` versus `professional-field*`, English supervisor fields. |
| Postdoc report cover | `\UseInstance{thu}{cover-p-a}` | `cover-p-a` | Report title, author, entry/exit dates. |
| Postdoc title page | `\UseInstance{thu}{cover-p-b}` | `cover-p-b` placeholder | Chinese/English titles, discipline levels, entry/exit dates. |
| Graduate proposal cover | `\UseInstance{thu}{cover-g-zh}` | `cover-g-zh` with proposal data | `thesis-type=proposal`, `student-id`, no `degree-category`. |

## Graduate Chinese Cover Layout Notes

The first layout parity target is the doctor academic Chinese cover without
secret information:

- oracle: `../thuthesis2e/thuthesis.dtx`, `\thu@titlepage@thesis`;
- local fixture: `testfiles/01-title-page/01-title-page-doctor-1-1.tex`;
- local instance: `\UseInstance{thu}{cover-g-zh}`.

The relevant `thuthesis2e` vertical skeleton is:

```latex
\newgeometry{ top=2cm, bottom=6cm, hmargin=3.5cm }
\thispagestyle{empty}
\null\vskip 8.1pt
\begingroup
  \centering
  \parbox[t][2cm][t]{\textwidth}{%
    \hskip -21.5pt%
    \thu@titlepage@secret
  }\par
  \vskip 40.5pt
  ... title ...
  \vskip 24.1pt
  ... degree/category ...
  \vfill
  ... info ...
\endgroup
```

The matching `thuthesis3` implementation rules are:

- Page `top-skip` must reproduce legacy `\null\vskip`, not a rule-based
  `\vspace*` substitute. The page template's `top-anchor = null` inserts an
  empty `\hbox:n{}` before applying `top-skip`. This reproduces the legacy
  `\null` anchor; a `\vspace*` substitute would suppress the later baseline
  glue and move the whole title/degree block.
- Element `bottom-skip` must be ordinary vertical glue. Between declared cover
  elements, use plain `\skip_vertical:N` so `bottom-skip = 24.1pt` behaves like
  the legacy `\vskip 24.1pt`.
- `g/cover/secret` is part of the vertical layout even when no secret is
  printed. It must reserve the same fixed box as the oracle:
  `\parbox[t][2cm][t]{\textwidth}{...}`.
- `g/cover/info` should keep the graduate Chinese cover's fixed wrapper:
  academic uses `\parbox[t][7.25cm][t]{\textwidth}{...}`; professional uses
  `\parbox[t][5.25cm][b]{\textwidth}{...}` followed by `62pt`.
- The info rows can be built from boxes instead of `tabular`, but the boxes
  must reproduce the old table geometry: `2.3cm` left indent, `6pt`
  tabular-left padding, `2.85cm` label pad, `2.75cm` stretched label text,
  `.77cm` colon pad, and `6pt` tabular-right padding. Each row also needs the
  old array strut, with height/depth `0.7/0.3` of the `31.2bp` row skip, and
  the rows should form one centered table object rather than separate
  paragraphs.
- The proposal `student-id` row is generated by `\@@_g_cover_stuid_item:NN`. It
  conditionally renders when `\g_@@_opt_proposal_bool` is true and is placed
  between the author and supervisor items in `\@@_g_cover_info_table:NN`. This
  follows the existing pattern of `\@@_g_cover_info_item:NN` and
  `\@@_g_cover_author_item:NN`.
- Graduate Chinese author/supervisor values should follow the old
  `\thu@name@title` layout: pad the stretched name to `3cm`, then typeset the
  title in `3em`. The older generic `4em + 1em + 3em` split places the title
  about `5pt` too far left.
- In `cover-g-zh`, author output is a fixed row between ordinary information
  rows and supervisor rows. Keep it as an explicit graduate author row rather
  than routing it through a case branch in the ordinary info-value formatter.
  This keeps the common row geometry shared while making the special value
  treatment local to the graduate cover.
- Be careful when removing `author` from a cover item list: the historical
  `\c_@@_name_coveritem_clist` is shared by docstrip branches. Graduate Chinese
  can emit author separately, but undergraduate `u / cover / info` still relies
  on the generic cover-info list to include its author row.
- The graduate secret mark format should use the explicit oracle metrics
  `\sffamily\fontsize{16bp}{20bp}\selectfont`. The generic
  `\@@_zihao:n { 3 }` selects a different line skip here, which changes the
  baseline glue after the fixed secret box.
- `g/cover/degree` should use the explicit oracle metrics
  `\fontsize{16bp}{22bp}\selectfont` plus `\@@_set_ccglue:N \c_@@_bp_dim`.
  The helper should also set the CJK family so the CJK glue is applied in the
  same font context as the legacy `thuthesis2e` code.
- `g/cover/date` should use a fixed-height top-aligned paragraph box equivalent
  to the legacy `\parbox[t][1.03cm][t]{\textwidth}{...}` shape. Prefer the
  local `\@@_box_paragraph:nnn` helper over spelling `\parbox` inside the
  instance. In the separated `xtemplate` element flow, keep the traced `-6pt`
  final correction after the date element; it corresponds to the final
  paragraph/strut behavior visible after the 2e date parbox and restores the
  page `\vfill` amount.

Do not compensate for a mismatch with a naked magic offset such as
`top-skip = -9.34pt`. That value can make one overlay look aligned, but it
only hides the real causes: missing `\null` behavior, wrong rule-based skip
semantics, or different font line metrics.

After these fixes, the visible title, degree, academic info rows, supervisor
title, and date text in `01-title-page-doctor-1-1` match the `thuthesis2e`
bbox coordinates. The following lower blocks still need separate parity work:

- the professional graduate info block has a different vertical contract and
  should be checked separately;
- proposal and engineering-master rows should be checked separately because
  they exercise `student-id`, professional-field, and engineering-field data.

For the reproducible overlay, bbox, and shipped-box trace commands, see
`llmdoc/reference/latexpagediff-verification.md`.

## Graduate English Cover Layout Notes

The first graduate English parity target is the doctor academic English cover:

- oracle: `../thuthesis2e/thuthesis.dtx`, `\thu@titlepage@en`;
- local fixture: `testfiles/01-title-page/01-title-page-doctor-2-1.tex`;
- local instance: `\UseInstance{thu}{cover-g-en}`.

The legacy title-page skeleton starts with `\null\vskip -0.31cm`, then typesets
the English title inside `\parbox[t][143bp][t]{\textwidth}{...}\par`. This
shape matters: the legacy paragraph box is an hbox containing a top-aligned
vbox, so the following vertical glue is governed by paragraph-line behavior, not
by a bare vertical-mode vbox.

Keep `g / cover-en / title` as a normal `element` instance. Do not add a
separate element template for this case, do not add `outer-format`,
`box-height`, or `box-width` keys to the generic element template, and do not
put style commands inside the `content` block. The title element should have one
format owner: `format = \sffamily \bfseries \@@_fontsize:nn { 20 bp } { 31.2 bp }`.

Use a dedicated paragraph-box helper for the title content instead of encoding
format in the instance body. The helper should default the width to
`\textwidth`, take only the fixed height and content, and reproduce the
top-aligned `143bp` parbox behavior. Because the element format has already set
the active 31.2bp line skip, the helper must compensate with
`\f@size pt - \baselineskip` before entering horizontal mode and building the
top-aligned vbox. This preserves the legacy first-line glue while keeping one
format setting on the element.

Keep the date box separate from the title helper. The graduate cover date still
uses its own fixed-height helper and the existing final `-6pt` correction; do
not let that date-specific correction leak into the English title box design.

The English supervisor block should reproduce `\thu@titlepage@en@supervisor`
without using LaTeX2e `tabular`. The old tabular has three important layout
effects: the label column is right-aligned; the colon column is a fixed
`20.5bp` box with `2bp` left padding; and all supervisor rows form one centered
box object inside the outer supervisor parbox. Drawing each row as a separate
paragraph can make the supervisor/date bboxes look close while moving the
preceding author block, because the old tabular's height/depth and baseline are
not reproduced.

The current direct-box implementation in `source/thuthesis3.dtx`
(`\@@_g_cover_en_supv:`, `\@@_g_cover_en_supv_table:N`) collects nonempty
English supervisor rows as a sequence of `{label}{value}` pairs and gives them
to one private `\halign`. TeX's alignment algorithm then chooses the natural
label/value column widths. The selector list `a,b,c` remains a simple `clist`
because it only names the three inherited fields; the structured row data uses
a `seq`. Rows are prebuilt into a token list before the alignment body is
scanned, keeping the mapping logic outside `\halign`.

Each aligned row uses `\strut` to recover the height/depth behavior that matters
for bbox parity. The outer supervisor area uses the same fixed-height top parbox
contract as `thuthesis2e`: academic English cover uses `3.0cm`; professional
English cover uses `3.37cm` with a different line-stretch contract. The doctor
academic English fixture matches the oracle bboxes for `Wang`, the supervisor
label/value rows, and `March` with this alignment shape.

Do not reuse the title-specific compensated paragraph-box helper for the
supervisor parbox. The title helper subtracts `\baselineskip - \f@size pt` to
match the first title line after `\null\vskip -0.31cm`; applying that same
compensation to the supervisor parbox shifts the author block relative to the
supervisor block. Use an uncompensated fixed-height top paragraph-box helper for
the supervisor area.

### English supervisor label and cover text

The former `supv a _en` name token (`Thesis Supervisor` / `Dissertation
Supervisor`) was split:

- `thesis _en` is defined via `\@@_define_name_grad:nnn` as `Thesis` (master) /
  `Dissertation \c_space_tl` (doctor).
- `supv a` is defined via `\@@_define_name_en:nn` as
  `\c_@@_name_thesis_en_tl Supervisor`, reusing the `thesis _en` token.

`\c_@@_text_cover_en_tl` now uses `\c_@@_name_thesis_en_tl` instead of the
former hardcoded `Dissertation~` in the first line.

When checking this area, do not regenerate `temp/comp.pdf` unless the user
explicitly asks for it. Use the focused fixture compile, bbox traces, and
shipped-box traces for investigation. In the doctor academic English fixture,
the top title word `Research`, first degree word `Dissertation`, `Tsinghua`,
`Applied`, author block `by` and `Wang Shaoping`, supervisor labels/values, and
date word `March` should match the `thuthesis2e` bbox coordinates after the
title and supervisor box fixes.

## thuthesis3 Gaps Against the Oracle

- Legacy isolated commands are collapsed: `\thu@titlepage` and
  `\thu@titlepage@en` both alias to `\maketitle`. The local title-page fixtures
  now bypass those commands and call `xtemplate` instances directly, so separate
  command-compatibility tests are still needed.
- Postdoc legacy commands are missing: `\thu@cover@postdoc` and
  `\thu@titlepage@postdoc` are currently undefined. The local postdoc fixtures
  now call `cover-p-a` and placeholder `cover-p-b` directly, so their saved
  `.tlg` files need regeneration after accepting the instance-isolation policy.
- `cover-p-b` is declared but has an empty element list, so the second postdoc
  page is only a placeholder.
- `cover-g-en` degree text is now handled through name lookup
  (`\@@_name:n`), and academic/professional differences are encoded by docstrip
  guards in the split `.def` files rather than runtime conditionals.
- `cover-u/secret` now uses the dynamic `\g_@@_info_secretlv_tl` and
  `\g_@@_info_secretyr_tl` info keys, matching the graduate Chinese cover pattern.
  The element uses `\parbox[t][0cm][t]{\textwidth}{...}` with right-flushed
  content and `19bp` bottom-skip.
- `cover-u` uses `top-anchor = none` (no `\null` anchor box before the first
  element), while graduate and postdoc pages use the default `top-anchor = null`
  to reproduce legacy `\null\vskip` positioning.
- `u/cover/name-img` was renamed to `u/cover/thulogo` and its inline content
  extracted into `\@@_u_cover_thulogo:`.
- `u/cover/title` uses `\@@_u_cover_title:` with `\@@_box_paragraph_top_to_ht:nn`
  for the `136bp` fixed-height parbox, plus explicit `\prevdepth` preservation
  and `\baselineskip`/`\lineskiplimit` compensation to match the legacy
  `\parbox` line-spacing contract.
- `u/cover/info` uses `bottom-skip = 0pt plus 1 fill`, reproducing the
  oracle's `\vfill` at `thuthesis2e/thuthesis.dtx` line 5187.
- `\@@_include_graphics:nn` (and its `nV` variant) was promoted from the
  `def-u` section to a shared class-level helper.
- The hook body selects page instances by docstrip guard (`def-u`, `def-g`,
  `def-p`), but it does not yet express all legacy runtime distinctions such as
  proposal versus thesis, optional spine, scan-file replacement, or isolated
  copyright/statement commands.
- `include-spine`, `spine-title`, `spine-author`, and `spine-font` info keys
  exist, but no LaTeX3 `\spine` page implementation is present yet.
- The current hook flow integrates copyright and originality pages differently
  from `thuthesis2e`, where `\copyrightpage` and `\statement` are separate
  public commands. `copyright` currently belongs to `cover/body` as `decl-a`;
  `originality` belongs to `cover/back` as `decl-b` and is scheduled at
  `enddocument` only by `\maketitle`. Decide whether this is intended before
  treating the hook flow as compatibility-complete.

## Cover TODO

- [x] Add a cover command compatibility layer:
  - `\thu@titlepage` renders only the family-appropriate Chinese cover;
  - `\thu@titlepage@en` renders only the graduate English cover;
  - `\thu@cover@postdoc` renders only `cover-p-a`;
  - `\thu@titlepage@postdoc` renders only `cover-p-b`.
  - Testfiles now exercise each cover through `\UseInstance` directly.
- [x] Keep `\maketitle` as the public full-flow command, with the hook body
  calling the same isolated rendering helpers so tests and production behavior
  use one implementation.
- [x] Eliminate runtime academic/professional dispatch:
  - split `graduate.def` into `graduate-academic.def` and
    `graduate-professional.def`;
  - remove `\@@_switch_name:`;
  - resolve label differences (`author`, `discip`, `e field`, `p field`,
    `pro degree`) through docstrip guards;
  - resolve info-block shape (`7.25cm`/`5.25cm`) through docstrip guards;
  - use `\@@_define_name_grad:nnn` for doctor/master name differences
    (e.g., `Thesis Supervisor` vs `Dissertation Supervisor`).
- [ ] Finish `cover-g-zh` parity:
  - [x] degree/category sentence for thesis and proposal (`\@@_g_cover_degree:`
    with `\bool_if:NTF \g_@@_opt_proposal_bool` dispatch);
  - engineering-master label behavior;
  - [x] proposal `student-id` (`\@@_g_cover_stuid_item:NN` conditionally renders
    when `\g_@@_opt_proposal_bool` is true, placed between author and supervisor
    items in `\@@_g_cover_info_table:NN`);
  - secret-level and secret-year rendering;
  - Chinese cover behavior when `language = english`.
- [ ] Finish `cover-g-en` parity:
  - professional field handling;
  - supervisor, associate supervisor, and co-supervisor label/content rules;
  - English date formatting.
- [x] Finish `cover-u` parity (bulk layout complete with spacing refinements, see below):
  - [x] dynamic secret rendering (`\g_@@_info_secretlv_tl` + `\g_@@_info_secretyr_tl`);
  - [x] logo/name-image dimensions and spacing (two-file system:
    `thu-fig-logo.pdf` at 50.4bp + `thu-text-logo.pdf` at 117bp raised 7bp,
    10bp gap, -5bp left shift);
  - [x] thesis label (`\ziju{0.3}`, `48bp` bottom-skip);
  - [x] title element (centered `\parbox[t][136bp]{\linewidth}` via
    `\@@_box_paragraph_top_to_ht:nn` with `\prevdepth` preservation and
    `\baselineskip`/`\lineskiplimit` compensation, `\fontsize{26bp}{32.5bp}`);
  - [x] date element (`\fontsize{16bp}{24bp}`, `\ziju{0.03}`, `60bp` bottom-skip,
    year-month format matching graduate);
  - [x] page geometry (`top=3.8cm, bottom=3.2cm, left=3.2cm, right=3cm`);
  - [x] `top-anchor = none` for the `cover-u` page instance (no `\null` anchor);
  - [x] `u/cover/name-img` renamed to `u/cover/thulogo`, content extracted to
    `\@@_u_cover_thulogo:`;
  - [x] info element: `bottom-skip = 0pt plus 1 fill` matches the
    oracle's `\vfill` (line 5187);
  - [x] info drawing mechanism: forked from graduate Chinese cover
    (`\@@_u_cover_info:*` mirroring `\@@_g_cover_info:*`), old generic
    `\@@_cover_info:` removed;
  - [ ] English-major title behavior (English title below Chinese title);
  - [ ] optional co-supervisor label width behavior;
  - [ ] bachelor proposal label if retained from the legacy surface.
- [ ] Merge `\@@_u_cover_info:*` and `\@@_g_cover_info:*` into one
  parameterized info-drawing system. The two are structurally identical
  (same `\@@_box_vcenter:n`, same `0.7/0.3` strut dims, same item/row
  decomposition, same three value-formatting paths). Only the left indent,
  label widths, and name/title stretch parameters differ.
- [ ] Finish postdoc parity:
  - populate `cover-p-b`;
  - verify `cover-p-a` against `\thu@cover@postdoc`;
  - implement postdoc top fields, dates, title/title* behavior, discipline
    level fields, and organization/date footer exactly as the oracle expects.
- [ ] Implement spine support:
  - provide a LaTeX3 `\spine` command or page instance;
  - honor `include-spine`, `spine-title`, `spine-author`, and `spine-font`;
  - preserve bachelor versus graduate geometry and font-size defaults.
- [ ] Decide and document the declaration-page contract:
  - either preserve separate `\copyrightpage` and `\statement` commands as
    user-facing compatibility APIs;
  - or document an intentional `thuthesis3` difference and adjust tests.
- [ ] Port and enable tests:
  - import `../thuthesis2e/testfiles/01-title-page-en/`;
  - add `testfiles/config-title-page-en.lua`;
  - continue expanding `testfiles/config-title-page.lua` (already includes
    proposal, needs secret, language=en, engineering-master, and remaining
	    variants);
  - remove the postdoc undefined-command expected failures once compatibility
    commands exist.
- [ ] Verify visual parity:
  - use l3build `.tlg` checks for command/log behavior;
  - use PDF or `pdfpagediff` comparison for layout-sensitive changes, because
    hook and template refactors can reorder logs while preserving output.
