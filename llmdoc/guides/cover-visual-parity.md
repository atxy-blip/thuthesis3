# Cover Visual Parity Workflow

## 适用场景

当封面布局、字体、行距、页顶 anchor、信息栏或 postdoc 页面发生变化时，用
本流程检查 `thuthesis3` 是否与 `thuthesis2e` oracle 绝对坐标一致。`.tlg`
只能证明 log/命令行为；封面页面必须以 PDF 和 bbox 为准。

## 输入路径

2e oracle fixture 根目录：
`C:\Users\admin\Documents\Source\thuthesis2e\testfiles\01-title-page`

3 implementation fixture 根目录：
`C:\Users\admin\Documents\Source\thuthesis3\testfiles\01-title-page`

默认在 `C:\Users\admin\Documents\Source\thuthesis3\temp` 放临时对比文件。
已有 overlay 模板是 `temp/comp.tex`。不要把临时 PDF、HTML、log 写入
`llmdoc/`。

## 对比顺序

1. 从 2e fixture 目录找到同名 oracle `.tex`，复制或改写为 temp 下的
   `*-2e.tex`，确保它使用 2e class 和对应 oracle implementation。
2. 从 3 fixture 目录找到新版 `.tex`，复制或改写为 temp 下的 `*-3.tex`，
   确保它使用当前 `thuthesis3` 生成物。
3. 分别编译生成 `*-2e.pdf` 和 `*-3.pdf`。从 temp 编译时，让当前目录和
   `build/test-testfiles/config-title-page` 位于 TeX 搜索路径前面。
4. 仿照 `temp/comp.tex` 使用 `pdfpagediff` 的 `\layerPages` 把两份 PDF
   叠加。先看整体红蓝差异，再进入 bbox 数值检查。
5. 使用 `pdftotext -bbox` 分别导出 2e 和 3 的 HTML。比较同一可见文本的
   `xMin`、`yMin`、`xMax`、`yMax`。顶部栏、UDC、标题、作者、日期等元素
   都应按文字节点或相邻节点精确对应。
6. 若 bbox 不一致但 source skip 看似相同，开启 shipped-box trace。比较
   `\topskip`、空 hbox、ordinary glue、parskip、baselineskip、hbox/vbox、
   tabular padding 和 strut 贡献，判断差异来自 anchor、font metric、
   parbox shape 还是 row/table internals。

## Postdoc 顶部栏检查

postdoc report cover 优先比较 `01-title-page-postdoc-1.tex`。顶部栏检查要
同时看视觉 overlay 和 bbox HTML：

- `UDC` 三个字母的字体族、字号、字重和字距应与 2e oracle 一致。
- 顶部栏各字段的 baseline 和左右间距应逐项匹配，不要只看整体 box 位置。
- 如果 `UDC` bbox 宽度或字母间距异常，先检查 font selection 和 letter
  spacing，再检查 horizontal skip。
- 如果顶部栏整体纵向错位，先检查 page top anchor 和 preceding glue，不要
  直接加 magic offset。

## 记录结果

稳定结论写入 `reference/cover-layout-contracts.md` 或
`reference/cover-migration-status.md`。一次性调查数据、HTML、截图和 PDF 放
`.llmdoc-tmp/` 或 `temp/`。如果流程本身暴露出文档缺口，记录到
`memory/doc-gaps.md`。
