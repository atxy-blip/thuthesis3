# llmdoc Index

全局文档地图。`startup.md` 只保存启动阅读顺序；本文件负责按任务路由。

## Must

- `must/repo-role-and-migration-policy.md`: 本仓库、`thuthesis2e` 与
  `NJUThesis-njulug` 的分工。
- `must/testing-and-oracle-policy.md`: 移植或接受 LaTeX3 模块前如何证明
  行为。

## Overview

- `overview/project-overview.md`: 仓库目的、顶层结构与当前状态。

## Architecture

- `architecture/source-and-build.md`: 源码入口、l3build、生成文件与禁止
  直接编辑的文件。
- `architecture/latex3-module-roadmap.md`: LaTeX3 模块地图与迁移顺序。
- `architecture/cover-system.md`: 封面系统的 page/element 模型、实例分类、
  docstrip 分层、角色/命令边界和布局不变量。

## Guides

- `guides/module-migration-workflow.md`: 在 `thuthesis2e` 验证模块并迁移到
  `thuthesis3` 的流程。
- `guides/cover-visual-parity.md`: 用 2e/3 fixture、`pdfpagediff` 叠图和
  PDF bbox HTML 检查封面绝对坐标一致性的流程。

## Reference

- `reference/class-options.md`: class option 继承规则与审计范围。
- `reference/setup-info-keys.md`: `\thusetup` 信息键、兼容别名和匿名过滤。
- `reference/language-interface.md`: `language`、`main-language` 和局部语言
  声明的现状。
- `reference/l3build-tests.md`: 本地测试配置与 `.tlg` 保存规则。
- `reference/llmdoc-writing-conventions.md`: llmdoc 的职责边界、拆分粒度、
  memory 写法和封面文档维护约定。
- `reference/latexpagediff-verification.md`: 通用 PDF 可视等价检查；封面
  专项使用 `guides/cover-visual-parity.md`。
- `reference/cover-oracles-and-fixtures.md`: 2e/3 封面 oracle 路径、fixture
  覆盖矩阵与当前测试入口。
- `reference/cover-layout-contracts.md`: 封面页面几何、字体、行距、bbox
  与 shipped-box 约束。
- `reference/cover-migration-status.md`: 封面迁移完成项、缺口和后续顺序。
- `reference/cover-xtemplate-dispatch-design.md`: cover role/sequence/instance
  dispatch 设计草案与剩余实现项。
- `reference/cover-structure-and-todo.md`: 历史封面总览文件；已拆分为上面
  的 cover architecture/reference/guide 文档。
- `reference/sibling-repositories.md`: 本地相关仓库路径与上游角色。
- `reference/latex3-patterns-from-njuthesis.md`: 可复用或需评估的 LaTeX3
  模式。
- `reference/tex-parameter-nesting.md`: 嵌套定义中的 TeX `#` 翻倍规则。
- `reference/git-commit-style.md`: 提交标题、issue suffix 与文档语言规则。
- `reference/versioning-and-changes.md`: pre-1.0 版本与 `\changes` 规则。

## Memory

- `memory/decisions/`: 稳定设计或流程决策。
- `memory/reflections/`: 任务后的反思、失败原因和可复用教训。
- `memory/doc-gaps.md`: 已知文档缺口。

临时调查材料放在 `.llmdoc-tmp/`，不要写入 `llmdoc/memory/`。
