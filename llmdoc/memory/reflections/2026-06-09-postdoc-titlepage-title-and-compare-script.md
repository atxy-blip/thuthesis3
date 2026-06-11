# 2026-06-09 博士后题名页题名段和 compare 脚本

## 任务

验证并修正 `cover-p-b` 题名段与 `thuthesis2e` 的 bbox 差异，同时把对比脚本中
`-OutRoot` 相对路径导致 overlay 失败的问题固化到工具和文档。

## 根因

`01-title-page-postdoc-2 -FirstWords 17` 显示中文题名比 oracle 低，而英文题名
比 oracle 高。两段方向相反，说明不是单一 page anchor 偏移。

中文题名的问题与 `cover-p-a` 标题相同：2e 在普通外部行距下输出固定高
`parbox`，而 3 版 element 把字号放在盒子外侧，导致盒子前的 normal
baselineskip glue 改变。英文题名的问题更直接：它没有放进 2e 的 `3cm`
fixed-height centered paragraph box。

脚本问题来自 `-OutRoot` 传入相对路径后，`Invoke-PdfLaTeX` 会先
`Push-Location` 到输出目录，再用相对 `comp.tex` 路径调用 `pdflatex`，从而在
错误目录下找文件。

## 可复用教训

- postdoc title page 的题名段可用 `-FirstWords 17` 单独验证，避免后半页信息栏
  和日期差异干扰定位。
- 中英文题名纵向差异方向相反时，优先检查 fixed-height `parbox` 和 line glue，
  不要先改整页 `top-skip`。
- 自定义 `-OutRoot` 必须在进入输出目录前解析为绝对路径。
- 修改 `.dtx` 后不要用 `-NoInstall` 直接验证，除非确认 `build/local` 已更新。

## 已提升知识

- `reference/cover-layout-contracts.md`: `cover-p-b` 题名段的 linefix 和
  fixed-height box 契约。
- `reference/cover-migration-status.md`: `cover-p-b` 题名段已 bbox match，
  剩余缺口是信息栏、起止日期和页脚日期。
- `guides/cover-visual-parity.md`: `-NoInstall`、`-OutRoot` 和
  `-FirstWords 17` 的使用说明。
- `.codex/skills/thuthesis-cover-compare`: 脚本和 skill 说明已同步更新。
