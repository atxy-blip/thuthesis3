# Cover Structure and TODO

This note organizes cover-related behavior from `../thuthesis2e` and the
current `thuthesis3` implementation, as inspected on 2026-05-06.

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
  `top-skip`, `bottom-skip`, bookmark fields, and page-level rendering;
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

Current local title-page fixtures in `thuthesis3` mirror only
`../thuthesis2e/testfiles/01-title-page/`:

- 29 imported fixtures total;
- no imported `01-title-page-en/` fixture tree yet;
- `testfiles/config-title-page.lua` currently runs only a smoke subset:
  bachelor, doctor-1-1, and master-1-1.

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
  `\vspace*` substitute. In the generic page template, place an empty hbox and
  then the requested skip. A zero-height rule suppresses the later baseline
  glue and moves the whole title/degree block.
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
- Graduate Chinese author/supervisor values should follow the old
  `\thu@name@title` layout: pad the stretched name to `3cm`, then typeset the
  title in `3em`. The older generic `4em + 1em + 3em` split places the title
  about `5pt` too far left.
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
without using `tabular`. The old tabular has three important layout effects:
the label column is right-aligned; the colon column is a fixed `20.5bp` box
with `2bp` left padding; and all supervisor rows form one centered box object
inside the outer supervisor parbox. Directly drawing each row as a separate
paragraph can make the supervisor/date bboxes look close while moving the
preceding author block, because the old tabular's height/depth and baseline are
not reproduced.

The clean direct-box implementation should first measure the nonempty English
supervisor labels and values, then draw rows from explicit hboxes. The rows must
be collected into one centered vertical box, using cached row strut dimensions
from the active supervisor line skip before any `\offinterlineskip` or
`vcenter`-style helper changes `\baselineskip`. The outer supervisor area uses
the same fixed-height top parbox contract as `thuthesis2e`:
academic English cover uses `3.0cm`; professional English cover uses `3.37cm`
with a different line-stretch contract.

Do not reuse the title-specific compensated paragraph-box helper for the
supervisor parbox. The title helper subtracts `\baselineskip - \f@size pt` to
match the first title line after `\null\vskip -0.31cm`; applying that same
compensation to the supervisor parbox shifts the author block relative to the
supervisor block. Use an uncompensated fixed-height top paragraph-box helper for
the supervisor area.

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
- `cover-g-en` still has incomplete degree text (`???`) and does not yet encode
  the academic/professional differences from `thuthesis2e`.
- `cover-u/secret` currently contains a fixed `机密10年` string instead of using
  the inherited secret-level and secret-year info keys.
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
- [ ] Finish `cover-g-zh` parity:
  - degree/category sentence for thesis and proposal;
  - academic/professional label switching;
  - engineering-master label behavior;
  - proposal `student-id`;
  - secret-level and secret-year rendering;
  - Chinese cover behavior when `language = english`.
- [ ] Finish `cover-g-en` parity:
  - master/doctor `Thesis` versus `Dissertation`;
  - academic versus professional layout;
  - professional field handling;
  - supervisor, associate supervisor, and co-supervisor label/content rules;
  - English date formatting.
- [ ] Finish `cover-u` parity:
  - dynamic secret rendering;
  - logo/name-image dimensions and spacing;
  - English-major title behavior;
  - optional co-supervisor label width behavior;
  - bachelor proposal label if retained from the legacy surface.
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
  - expand `testfiles/config-title-page.lua` beyond the smoke subset when each
    family is implemented;
  - remove the postdoc undefined-command expected failures once compatibility
    commands exist.
- [ ] Verify visual parity:
  - use l3build `.tlg` checks for command/log behavior;
  - use PDF or `pdfpagediff` comparison for layout-sensitive changes, because
    hook and template refactors can reorder logs while preserving output.
