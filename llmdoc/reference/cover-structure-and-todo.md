# Cover Structure and TODO

本文件原来是封面系统的总览、fixture 表、布局笔记和 TODO 混合文档。2026-05-27
按 ctex-kit 风格拆分为职责更清楚的文档；不要再把新的稳定知识追加到这里。

## 新入口

- `architecture/cover-system.md`: 封面系统的结构、分层、dispatch 边界和
  layout 不变量。
- `reference/cover-oracles-and-fixtures.md`: 2e/3 oracle 路径、fixture
  覆盖矩阵和优先 parity target。
- `reference/cover-layout-contracts.md`: graduate、undergraduate、postdoc
  页面几何、字体、行距和 bbox 契约。
- `reference/cover-migration-status.md`: 已完成项、未完成项和推荐顺序。
- `guides/cover-visual-parity.md`: overlay、PDF bbox HTML 和 shipped-box
  trace 的实际对比流程。
- `reference/cover-xtemplate-dispatch-design.md`: role/sequence/instance
  dispatch 设计草案。

## 维护规则

封面新增知识按职责写入上面的目标文件。一次性调查放 `.llmdoc-tmp/` 或
`temp/`。如果发现缺少长期文档入口，记录到 `memory/doc-gaps.md`。
