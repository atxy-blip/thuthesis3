# 2026-06-09 博士后题名页信息栏

## 任务

把 `cover-p-b` 的三行信息栏对齐到 `thuthesis2e` 的
`01-title-page-postdoc-2` oracle，使题名段加信息栏的前 28 个 text elements
达到 bbox match。

## 根因

原 3 版信息栏是三个连续左对齐 hbox：第一列没有复现
`\thu@stretch{11em}{...}`，整个信息对象也没有像 2e 的
`tabular{l@{\quad}l}` 一样按自然宽度居中。因此标签没有 spread，value 列也
整体偏左。

直接改用公共 `tabular` 不是等价替代。本仓库对 `tabular` 有全局 begin hook，
会改变字号，破坏 postdoc 题名页局部 `\xiaosi[2.6]` 的 oracle 契约。

## 可复用教训

- 先用 `-FirstWords 28` 把题名段和信息栏作为一个局部目标；完整页面仍可从
  日期区开始失败。
- 复现 legacy `tabular` 时，如果全局环境 hook 会改变局部排版，优先写私有
  alignment 来复现自然宽度、`tabcolsep`、`@{\quad}` 和 `\strut`。
- 第一列应使用 `\@@_box_ss:nn {11em}`；`博士后姓名` 被拆为单字 bbox 是预期
  输出，不应合并成一个普通词盒。
- 第二列短中文值需要 `\hfil`，否则会被 alignment 剩余宽度拉散。
- 微小 ink 起点补偿不能参与列宽计算；用零宽盒叠加可避免破坏整个表格居中。

## 已提升知识

- `reference/cover-layout-contracts.md`: `cover-p-b` 信息栏的 spread box、
  私有 alignment、公共 `tabular` 禁用原因和 value ink 补偿契约。
- `reference/cover-migration-status.md`: `cover-p-b` 前 28 个 text elements 已
  bbox match，剩余缺口只包括起止日期和页脚日期。
- `guides/cover-visual-parity.md`: postdoc title page 信息栏可用
  `-FirstWords 28` 做局部验证。
