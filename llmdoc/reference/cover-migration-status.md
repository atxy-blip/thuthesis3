# Cover Migration Status

## 已完成的结构工作

- `\maketitle` 保持 public full-flow 入口。
- family cover pages 使用 `xtemplate` page/element instances。
- cover command compatibility layer 已添加：`\thu@titlepage`、
  `\thu@titlepage@en`、`\thu@cover@postdoc`、`\thu@titlepage@postdoc`。
- graduate academic/professional `.def` 已拆分为 docstrip-time separation。
- `\@@_define_name_grad:nnn` 局部化 doctor/master name differences。
- graduate thesis/proposal degree/category text 由 `\@@_g_cover_degree:`
  处理。
- proposal `student-id` row 已进入 graduate Chinese info flow。
- undergraduate cover 大部分布局 parity 已完成，包括 secret、logo、type
  label、title、date、geometry、`top-anchor=none`、info `vfill` 和
  English-main title behavior。
- undergraduate/graduate Chinese info system 已合并为 class-level 参数化
  绘制系统。

## 未完成或需复验

- graduate Chinese: engineering-master label behavior、secret rendering、
  `language=english` Chinese cover。
- graduate English: professional field、supervisor/associate/co-supervisor
  label/content rules、English date formatting。
- undergraduate: optional co-supervisor label width behavior。
- shared info system: `\@@_u_cover_info_table:` 仍应重命名为
  `\@@_cover_info_table:`。
- postdoc: `cover-p-b` 仍是 placeholder；`cover-p-a` 和 postdoc 顶部栏
  需要完整 parity 验证。`cover-p-a` 的顶部栏、报告字样、标题和作者在
  `01-title-page-postdoc-1` 前 20 个 text elements 上已可 bbox match；
  日期信息栏、页脚日期和 `01-title-page-postdoc-2` 仍需继续对齐。
- spine: `include-spine`、`spine-title`、`spine-author`、`spine-font` 有 key，
  但 LaTeX3 `\spine` page/command 仍未完成。
- declaration pages: 需要决定是否保持 `\copyrightpage` 和 `\statement`
  作为独立 public compatibility APIs，或明确记录 intentional difference。
- tests: `01-title-page-en` 尚未导入；`config-title-page.lua` 仍需覆盖 secret、
  English-main、engineering-master 和剩余 postdoc variants。

## 推荐顺序

1. 继续用 `guides/cover-visual-parity.md` 对齐 postdoc `cover-p-a` 的日期
   信息栏和页脚日期。
2. 填充并验证 `cover-p-b`。
3. 补 graduate Chinese 剩余 variants，再补 graduate English professional
   variants。
4. 导入 `01-title-page-en` fixture tree 后扩展 config。
5. 最后处理 spine 与 declaration-page public API，因为它们影响页面流程而
   不只是单页几何。
