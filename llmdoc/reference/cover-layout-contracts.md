# Cover Layout Contracts

## 通用原则

封面布局以 `thuthesis2e` PDF 行为为 oracle。源码层看似等价的 `\vspace*`、
`parbox`、`vbox`、`tabular` 和 direct box 实现可能产生不同的 top glue、
baseline glue、strut、font metric 或 bbox。接受修改前必须用 PDF 叠图和
bbox HTML 验证，而不只看 `.tlg`。

`page` template 的 `top-anchor=null` 复现 `\null\vskip`；`top-anchor=none`
用于 undergraduate cover。不要用裸 offset 补偿全页错位。

## Graduate Chinese Cover

首个 parity target 是 doctor academic Chinese cover without secret：
`testfiles/01-title-page/01-title-page-doctor-1-1.tex`。oracle surface 是
`thuthesis2e/thuthesis.dtx` 的 `\thu@titlepage@thesis`。

稳定布局契约：

- page geometry: legacy `top=2cm, bottom=6cm, hmargin=3.5cm`
- page start: legacy `\null\vskip 8.1pt`，由 `top-anchor=null` 和 `top-skip`
  复现
- secret block: 即使没有 secret 文字也保留固定 `2cm` top-aligned box
- element skips: element 间使用 ordinary vertical glue，不使用 rule-based
  substitute
- info block: academic 使用 `7.25cm` top parbox；professional 使用 `5.25cm`
  bottom parbox 后接 `62pt`
- info row geometry: `2.3cm` left indent、`6pt` tabular-left padding、
  `2.85cm` label pad、`2.75cm` stretched label text、`.77cm` colon pad、
  `6pt` tabular-right padding
- row strut: height/depth 为 row skip 的 `0.7/0.3`，复现 `array` strut
- author/supervisor value: name pad 到 `3cm`，title 用 `3em`
- secret mark font: `\sffamily` with `16bp/20bp`
- degree/category font: `16bp/22bp` and CJK glue in the same font context
- date box: fixed-height top paragraph box equivalent to legacy `1.03cm`
  parbox, with traced final `-6pt` correction

已对齐的 doctor academic Chinese bbox 目标：

| Text item | Oracle yMin | thuthesis3 yMin |
| --- | ---: | ---: |
| title first line | `180.789` | `180.789` |
| title second line | `227.589` | `227.589` |
| degree/category line | `282.189` | `282.189` |
| department value | `450.180` | `450.180` |
| discipline value | `481.380` | `481.380` |
| author value | `512.580` | `512.580` |
| supervisor value | `543.780` | `543.780` |
| date | `648.035` | `648.035` |

professional info block、proposal student-id、engineering-master rows 和
`language=english` Chinese cover 需要分别验证。

## Graduate English Cover

首个 parity target 是 `01-title-page-doctor-2-1.tex`。oracle surface 是
`thuthesis2e/thuthesis.dtx` 的 `\thu@titlepage@en`。

稳定布局契约：

- page start: legacy `\null\vskip -0.31cm`
- title: top-aligned fixed-height `143bp` paragraph box inside a normal element
- title format owner: element `format`，不要把 style command 放进 content
- title helper: 需要补偿 `\baselineskip - \f@size pt` 以复现 first-line glue
- date helper: 与 title helper 分离，date 保留自己的 fixed-height box 和
  final correction
- supervisor block: 用一个 centered alignment object 复现 legacy `tabular`
  行为，不要把每行画成独立 paragraph
- supervisor row: label column right-aligned；colon column 是固定 `20.5bp`
  box 且有 `2bp` left padding；row 使用 `\strut`
- outer supervisor area: academic 使用 `3.0cm` fixed top parbox；
  professional 使用 `3.37cm` 并有不同 line-stretch contract

`thesis _en` token 保存 master/doctor 的 Thesis/Dissertation 差异；
`supv a` 复用该 token 组合 supervisor label；English cover text 也应复用
同一个 thesis token，不要硬编码 `Dissertation`。

## Undergraduate Cover

undergraduate cover 使用 `top-anchor=none`。页面从 fixed zero-height secret
box 开始，而不是 `\null` anchor。

稳定布局契约：

- page geometry: `top=3.8cm, bottom=3.2cm, left=3.2cm, right=3cm`
- secret: 动态 `secret-level`/`secret-year`，right-flushed，fixed top box
- logo: two-file system，`thu-fig-logo.pdf` and `thu-text-logo.pdf`
- type label: `\ziju{0.3}` and proposal/thesis dispatch by
  `\@@_u_cover_type:`
- title: `\heiti` with `26bp/32.5bp`，不是 `\sffamily`
- English-main title: Chinese title plus `title*` below it，只对英文标题局部
  应用 English punctuation
- info: `bottom-skip = 0pt plus 1 fill` 复现 legacy `\vfill`

optional co-supervisor label width behavior 仍需验证。

## Postdoc Cover

postdoc 有两个页面槽位：`cover-p-a` 是 report cover，`cover-p-b` 是 title
page。`cover-p-b` 仍是 placeholder；postdoc 顶部信息栏、UDC 字体/间距、
中英文标题、discipline level、起止日期和页脚日期都应按 2e oracle 分项
验证。

postdoc parity 优先使用 `testfiles/01-title-page/01-title-page-postdoc-1.tex`
和 `01-title-page-postdoc-2.tex`，流程见 `guides/cover-visual-parity.md`。
