# 2026-05-27 博士后封面标题行距修正

## 任务

把博士后 `cover-p-a` 标题区域对齐到 `thuthesis2e` oracle，同时重构 parbox
替代实现，避免本科和博士后封面标题各自私有一份行间胶补偿逻辑。

## 摘要

bbox 对比首先显示，博士后封面顶部信息栏和报告标题已经纵向对齐。第一个有
意义的错位从博士后标题开始，因此调查范围可以收窄到标题盒子，而不是整页
布局。

这里有两个相互独立但都会影响结果的细节：

- 旧实现把标题字号放在固定高度 parbox 内部，而 `xtemplate` element 模型把
  字体选择放在内容 helper 外侧的 element format 中；
- 旧博士后标题下划线是 XeTeX 下经由 `xeCJKfntef` / `ulem` 得到的直接
  `\uline`，并且局部设置了 `\ULthickness = 0.7pt` 和
  `\ULdepth = 1em`。

最终 helper 是 `\@@_box_linefix:nn`，参数是要复现的外部基准行距和一个固定
高度盒子。本科标题使用 `0pt` 复现旧的局部行为；博士后标题使用 `20bp`，
这是旧实现进入标题 parbox 前普通正文环境的基准行距。博士后标题的垂直居中
通过 `\@@_box_paragraph_center_to_ht:nn` 表达，而不是给 linefix helper 增加
内部定位参数。

## 做得好的地方

- bbox 报告是正确的第一诊断入口：标题以上元素精确对齐，说明问题不在整页
  偏移或顶部信息栏尺寸。
- 字体选择保留在标题内容外侧，符合 element 模型，也避免在一次性 helper 内
  复制字号设置。
- 本科标题用当前输出和前一个本地实现做 A/B 对比，可以在完整本科 oracle
  仍有无关迁移缺口时单独排除回归。
- 最终 helper 足够短，参数化的正是实际契约：固定高度段落盒子之前要复现的
  外部行距。

## 绕路原因

- 修改 `source/thuthesis3.dtx` 后如果直接用 `-NoInstall` 运行 cover-compare
  skill，可能比较到旧的生成文件。源码修改后必须先 `l3build install`，再做
  no-install 对比。
- 最初的抽象过度泛化。隐藏的 normal-baseline 常量、内部定位参数和
  `\prevdepth=-1000pt` 哨兵判断，都会把 helper 推向通用 TeX primitive，
  但这里实际需要的只是窄范围封面布局操作。
- 最初对 `20bp` 的解释是错的：它不是四号标题的基线高度，而是 LaTeX2e
  oracle 进入标题 parbox 前的普通外部基准行距。
- 下划线一开始没有查足。复用 `\thuline` 或固定宽度下划线 helper 并不等价，
  因为旧实现的宽度和垂直尺寸来自直接 `\uline` 以及局部
  `\ULthickness` / `\ULdepth` 设置。

## 根因

视觉错位来自把字体选择移出旧 parbox 后，没有同时保留 TeX 在固定高度盒子前
插入的行间胶。这个胶由外部 `\baselineskip`、上一行深度和盒子高度共同决定。
外部字体环境改变时，parbox 本身高度可能正确，但落点仍会发生纵向偏移。

博士后标题又暴露了第二个旧实现依赖：下划线尺寸也是标题盒子可测行为的一部分。
当 oracle 在 `\uline` 附近修改 `\ULthickness` 和 `\ULdepth` 时，只匹配文字、
字号和盒子高度是不够的。

## 缺失文档或信号

| # | Gap | Where it should go |
|---|-----|--------------------|
| 1 | cover 对比流程应说明：修改 `.dtx` 后，使用 `-NoInstall` 前必须先 `l3build install`。 | `guides/cover-visual-parity.md` |
| 2 | 当完整 2e oracle 仍有已知无关缺口时，流程应推荐用旧的 `thuthesis3` 输出做局部 A/B 回归检查。 | `guides/cover-visual-parity.md` |
| 3 | 已对齐的标题/作者前缀之后，博士后剩余日期行和页脚仍需要单独 bbox 调查，不能默认被标题 helper 顺带修好。 | `reference/cover-migration-status.md` |

## 可提升知识

- 已提升到稳定文档：固定高度段落盒子的契约、`\@@_box_linefix:nn`、目标基准
  行距、博士后直接 `\uline` 尺寸，以及不使用哨兵值的规则，属于
  `reference/cover-layout-contracts.md`。
- 已提升到稳定文档：`xtemplate` element 粒度的成本收益判断，属于
  `architecture/cover-system.md`。
- 仍待提升的流程知识：先 install 再 compare，以及在完整 oracle 有已知无关
  缺口时做本地 A/B 回归检查，下次编辑 `guides/cover-visual-parity.md` 时补入。
