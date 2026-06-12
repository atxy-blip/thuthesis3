# 2026-06-12 biblatex hook 迁移反思

## 背景

本次把 `thuthesis3` 的 biblatex 处理从 `BeforeBeginEnvironment{document}`
里的手动 `pre -> \RequirePackage -> post` 串联，迁移到 LaTeX package hooks：

- `package/biblatex/before`: 传入加载期 style 设置。
- `package/biblatex/after`: 执行普通 biblatex option，设置 heading，导入资源。
- `env/document/before`: 用户没有手动载入时的后备自动载入。

目标是匹配 `../NJUThesis-njulug` 已验证的机制，同时尽可能保留
`../thuthesis2e` 用户手动载入 `biblatex` 后再打补丁的接口语义。

## 绕路

最初新增 l3build 用例后直接运行 `l3build check`，先得到的是“缺少 `.tlg`”
而不是行为失败。随后又用 `l3build save` 在旧实现下生成了一份坏基线；它记录了
未定义引用和空 bibliography，而不是期望行为。

修正方式是把测试收窄到明确的可观测状态：输出资源 clist 数量和最终
`\blx@bbxfile`，同时保留完整 Biber 编译和 `\printbibliography`。旧实现因此能
清楚暴露 `style` 太晚传入、资源太晚导入的问题。

## 教训

- biblatex 回归测试要先设计能区分旧/新行为的断言，再保存 `.tlg`。
- 不要在旧实现下保存 `.tlg` 当作期望基线；先确认红测失败原因是目标行为缺失。
- 对 biblatex 行为，仅检查内部变量不够；要保留 Biber 和
  `\printbibliography`，否则资源导入时序问题会漏掉。
- `../NJUThesis-njulug` 可照搬机制，但不能照搬 API 结论；ThuThesis 的兼容边界
  要单独写清。
- 默认 `l3build check` 仍会碰到 title-page `.tlg` 漂移；报告验证结果时要把
  biblatex 配置通过和既有 title-page 差异分开。

## 已提升到稳定文档

- `llmdoc/architecture/biblatex-hook-loading.md`
- `llmdoc/reference/l3build-tests.md`
- `llmdoc/architecture/latex3-module-roadmap.md`
