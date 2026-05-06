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

- `testfiles/01-title-page/`: 30 fixtures:
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
  - `cover-g`;
  - `cover-g-en`;
  - `cover-a-p`;
  - `cover-b-p`;
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
2. Graduate Chinese cover instance: `cover-g`.
3. Graduate English cover instance: `cover-g-en`.
4. Postdoc report cover instance: `cover-a-p`.
5. Postdoc title-page placeholder: `cover-b-p`.
6. Copyright page instance: `copyright`.
7. Originality statement instance: `originality`.

Current local title-page fixtures in `thuthesis3` mirror only
`../thuthesis2e/testfiles/01-title-page/`:

- 30 imported fixtures total;
- no imported `01-title-page-en/` fixture tree yet;
- `testfiles/config-title-page.lua` currently runs only a smoke subset:
  bachelor, doctor-1-1, and master-1-1.

## thuthesis3 Gaps Against the Oracle

- Legacy isolated commands are collapsed: `\thu@titlepage` and
  `\thu@titlepage@en` both alias to `\maketitle`, so tests that mean "only the
  Chinese cover" or "only the English cover" do not yet exercise the same
  surface as `thuthesis2e`.
- Postdoc legacy commands are missing: `\thu@cover@postdoc` and
  `\thu@titlepage@postdoc` are currently undefined, and the imported postdoc
  `.tlg` files record those undefined-control-sequence failures.
- `cover-b-p` is declared but has an empty element list, so the second postdoc
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

1. Add a cover command compatibility layer:
   - `\thu@titlepage` should render only the family-appropriate Chinese cover;
   - `\thu@titlepage@en` should render only the graduate English cover;
   - `\thu@cover@postdoc` should render only `cover-a-p`;
   - `\thu@titlepage@postdoc` should render only `cover-b-p`.
2. Keep `\maketitle` as the public full-flow command, but make the hook body
   call the same isolated rendering helpers so tests and production behavior use
   one implementation.
3. Finish `cover-g` parity:
   - degree/category sentence for thesis and proposal;
   - academic/professional label switching;
   - engineering-master label behavior;
   - proposal `student-id`;
   - secret-level and secret-year rendering;
   - Chinese cover behavior when `language = english`.
4. Finish `cover-g-en` parity:
   - master/doctor `Thesis` versus `Dissertation`;
   - academic versus professional layout;
   - professional field handling;
   - supervisor, associate supervisor, and co-supervisor label/content rules;
   - English date formatting.
5. Finish `cover-u` parity:
   - dynamic secret rendering;
   - logo/name-image dimensions and spacing;
   - English-major title behavior;
   - optional co-supervisor label width behavior;
   - bachelor proposal label if retained from the legacy surface.
6. Finish postdoc parity:
   - populate `cover-b-p`;
   - verify `cover-a-p` against `\thu@cover@postdoc`;
   - implement postdoc top fields, dates, title/title* behavior, discipline
     level fields, and organization/date footer exactly as the oracle expects.
7. Implement spine support:
   - provide a LaTeX3 `\spine` command or page instance;
   - honor `include-spine`, `spine-title`, `spine-author`, and `spine-font`;
   - preserve bachelor versus graduate geometry and font-size defaults.
8. Decide and document the declaration-page contract:
   - either preserve separate `\copyrightpage` and `\statement` commands as
     user-facing compatibility APIs;
   - or document an intentional `thuthesis3` difference and adjust tests.
9. Port and enable tests:
   - import `../thuthesis2e/testfiles/01-title-page-en/`;
   - add `testfiles/config-title-page-en.lua`;
   - expand `testfiles/config-title-page.lua` beyond the smoke subset when each
     family is implemented;
   - remove the postdoc undefined-command expected failures once compatibility
     commands exist.
10. Verify visual parity:
    - use l3build `.tlg` checks for command/log behavior;
    - use PDF or `pdfpagediff` comparison for layout-sensitive changes, because
      hook and template refactors can reorder logs while preserving output.
