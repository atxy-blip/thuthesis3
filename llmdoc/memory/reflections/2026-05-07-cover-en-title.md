# 2026-05-07 Cover English Title Box

The graduate English cover title alignment problem is a paragraph-box problem,
not a reason to extend the `xtemplate` element abstraction. The target behavior
comes from `../thuthesis2e/thuthesis.dtx` (`\thu@titlepage@en`): the title is
inside a top-aligned fixed-height parbox after `\null\vskip -0.31cm`.

Accepted design constraint: keep `g / cover-en / title` as a normal element with
one `format` setting. The title content may call a helper that owns box shape,
but the content block must not contain font or style commands. Width can stay
implicit as `\textwidth`; the helper only needs height and content.

Rejected approaches: putting `\sffamily`, `\bfseries`, or font-size commands in
the `content` block; adding a new `parbox-element` template without a broader
template decision; adding `outer-format`, `box-height`, or `box-width` keys to
the generic element template for one title-box case. These approaches split
format ownership and make the instance harder to reason about.

The clean helper behavior is to compensate the active line skip before building
the top-aligned fixed-height vbox. This reproduces the legacy parbox line-glue
effect while preserving the `xtemplate` separation of format and content.

Do not regenerate `temp/comp.pdf` during this investigation unless the user
explicitly asks for it. Prefer focused fixture compiles, bbox comparisons, and
shipped-box traces. After the helper fix, `Research`, the first `Dissertation`,
`Tsinghua`, `Applied`, and `March` in `01-title-page-doctor-2-1` match the
`thuthesis2e` bbox coordinates; lower author/supervisor alignment remains a
separate parity problem.

Follow-up lesson for the supervisor block: removing `tabular` is not enough.
`thuthesis2e` uses `\thu@titlepage@en@supervisor` as a tabular inside a
fixed-height supervisor parbox. The direct LaTeX3 version must draw rows from
hboxes, but the rows still need to form one centered box object with the old
height/depth behavior. Separate centered paragraph rows can make the supervisor
text itself look aligned while shifting the preceding author block.

Do not reuse the title helper's line-skip compensation for supervisor content.
That compensation belongs to the top title parbox only. The supervisor parbox
needs an uncompensated fixed-height top box, while its direct rows cache the
active supervisor line skip before entering the centered vertical box. After
this correction, `by`, `Wang Shaoping`, the supervisor labels/values, and
`March, 2002` in `01-title-page-doctor-2-1` match the `thuthesis2e` bbox
coordinates.
