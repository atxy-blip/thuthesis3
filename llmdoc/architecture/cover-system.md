# Cover System Architecture

## 定位

封面系统负责把 `thuthesis2e` 的 bachelor、graduate、postdoc、spine、
copyright 和 originality 页面行为映射到 `thuthesis3` 的 LaTeX3/`xtemplate`
实现。行为 oracle 是 `thuthesis2e`，维护入口是
`source/thuthesis3.dtx`，不要修改生成的 `.cls` 或 `.def` 文件。

`reference/cover-oracles-and-fixtures.md` 记录 fixture 与 oracle 路径；
`reference/cover-layout-contracts.md` 记录页面级布局契约；可视对比流程见
`guides/cover-visual-parity.md`。

## 2e 页面表面

`thuthesis2e` 有五类主要封面/题名页和一个可选书脊：

- bachelor Chinese cover: `\thu@titlepage@bachelor`
- graduate Chinese thesis/proposal cover: `\thu@titlepage@thesis`
- graduate English cover: `\thu@titlepage@en`
- postdoc report cover: `\thu@cover@postdoc`
- postdoc title page: `\thu@titlepage@postdoc`
- optional spine: `\spine`

copyright 和 statement 是相关但独立的 public page commands。不要把这些
命令的兼容性误认为 `\maketitle` 内部流程的副产品。

## thuthesis3 页面模型

当前实现使用 `xtemplate` object type `thu`。通用 `element` template 负责
content、format、bottom-skip 和 align；通用 `page` template 负责 element
列表、prefix、geometry、format、top-anchor、top-skip、bottom-skip、bookmark
和页面渲染。

当前短实例名是迁移期约定：

- `cover-u`: undergraduate Chinese cover
- `cover-g-zh`: graduate Chinese thesis/proposal cover
- `cover-g-en`: graduate English cover
- `cover-p-a`: postdoc report cover
- `cover-p-b`: postdoc title page placeholder
- `copyright`: declaration/authorization page instance
- `originality`: originality statement instance

命名保持 family-first。graduate 使用 `zh`/`en` 因为轴是语言；postdoc 使用
`a`/`b` 因为轴是固定页面槽位。避免 `cover-a-p`、`cover-b-p` 这类隐藏
family 轴的旧拼法。

## Dispatch 边界

长期目标是 public command -> cover sequence -> cover role -> page instance。
`reference/cover-xtemplate-dispatch-design.md` 记录 role/sequence 设计和实现
顺序。稳定边界是：public commands 和 hooks 不应直接知道所有具体页面实例；
family、degree-type 和 thesis-type 的差异应分别落到 docstrip、name lookup
或局部 bool dispatch。

`thuthesis3/cover/begin`、`thuthesis3/cover/body`、`thuthesis3/cover/end` 和
`thuthesis3/cover/back` 是 hook anchor。`cover/back` 是封底/声明材料的语义
位置；`\maketitle` 只在被调用时把它连到一次性的 `enddocument` 执行点。

## Docstrip 分层

graduate definition 已拆为 academic 和 professional 两个 docstrip target：

- `thuthesis3-graduate-academic.def`: guards `def-g,def-g-aca`
- `thuthesis3-graduate-professional.def`: guards `def-g,def-g-pro`

共享 graduate 代码使用 `def-g`。academic-only 代码使用 `def-g-aca`；
professional-only 代码使用 `def-g-pro`。优先使用 docstrip-time 分离表达
degree-type 差异，避免在渲染函数中散布 `\int_compare:nTF`。

doctor/master 名称差异使用 `\@@_define_name_grad:nnn` 局部化；thesis/proposal
文本差异允许在共享函数中使用 `\bool_if:NTF \g_@@_opt_proposal_bool`，前提是
两支只是在组合 name tokens，而不是改变页面结构。

## Layout 不变量

`page` template 的 `top-anchor` 是封面定位关键：

- `null`: 插入空 `\hbox:n {}` 后再应用 `top-skip`，复现 legacy
  `\null\vskip` 行为；graduate 和 postdoc 页面使用。
- `none`: 不插入 anchor box，页面直接从第一个 element 开始；undergraduate
  cover 使用。

不要用裸 magic offset 修正全页偏移。若 overlay 只靠一个偏移量变好，通常
说明 `\null` anchor、ordinary vertical glue、font line metrics 或 parbox
形状没有复现。

## Cover Info 系统

undergraduate 和 graduate Chinese cover 信息区共享 class-level 参数化绘制
系统。稳定职责如下：

- `\@@_cover_info_dims:` 设置 strut height/depth、label/text width。
- `\@@_cover_info_body:` 负责左缩进、tabular padding 和统一 row body。
- item generators 选择普通信息、author、student-id 或 supervisor 路径。
- row dispatchers 共享 `\@@_cover_row_info:nn` 的 label/colon/value 几何。

per-family 差异只应出现在 left indent、label/text dims、name/title formatting
和外层 box shape。`\@@_u_cover_info_table:` 名称仍带 `_u_` 前缀，但语义已
共享，后续应重命名为 `\@@_cover_info_table:`。

## Helper Locality

封面专用 helper 应靠近调用它的 element 或 page instance。只有真正跨 family
共享的 box、name、date、setup 和 graphics helper 才放在通用 helper 区。
这条规则能让每个 helper 的 legacy metric 归属更清楚，避免把局部页面补偿
误提升为全局 primitive。
