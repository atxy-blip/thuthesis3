# BibLaTeX Hook Loading

## 定位

`thuthesis3` 的 biblatex 集成负责在保留用户手动载入 `biblatex` 空间的同时，
接入模板收集的样式、选项和资源。它借鉴
`../NJUThesis-njulug` 的 package hook 机制，但公开行为必须服务 ThuThesis
兼容性。

当前实现入口是 `source/thuthesis3.dtx` 的参考文献小节：

- `\g_@@_blx_style_clist`: 保存 `bib/style` 转换出的加载期样式选项。
- `\g_@@_blx_option_clist`: 保存 `bib/option` 中载入后执行的选项。
- `\g_@@_blx_resource_clist`: 保存 `bib/resource` 和临时
  `\addbibresource` 收集到的资源。
- `\@@_blx_pre_setup:`: 在 `package/biblatex/before` 释放临时
  `\addbibresource`，并把 style clist 传给 `biblatex`。
- `\@@_blx_post_setup:`: 在 `package/biblatex/after` 执行普通选项、设置
  bibliography heading，并逐项导入资源。

## 用户路径

默认路径：用户不手动载入 `biblatex` 时，`env/document/before` 后备执行
`\RequirePackage { biblatex }`。package hooks 仍负责前后设置。

手动补丁路径：用户先写 `\thusetup[bib]{...}`，再手动
`\usepackage{biblatex}`，模板的 style、option 和 resource 仍会接入；用户随后
可以写 biblatex 补丁。

退出路径：`biblatex = false` 表示完整退出 thuthesis3 的 biblatex 集成；不要
注册临时 `\addbibresource`、package hooks 或自动载入 hook。

不要承诺在 `biblatex` 已载入后再调用 `\thusetup[bib]{...}` 仍能完整实时生效。
当前稳定边界是 setup 先于手动 package load。

## 兼容边界

`../thuthesis2e` 的用户接口主要是手动
`\usepackage[style=...]{biblatex}` 后使用 `\addbibresource` 和
`\printbibliography`。`thuthesis3` 已有 `\thusetup[bib]{style, option,
resource}` 接口；hook 迁移的兼容目标是让用户仍能手动载入 `biblatex` 并在其后
补丁，而不是复制 NJUThesis 的用户 API。

`thuthesis3` 当前尚未随包提供 `thuthesis-*.bbx/cbx` 样式文件。因此
`bib/style = numeric` 和 `author-year` 仍映射到现有 GB/T 样式。不要把默认映射
改到缺失的 `thuthesis-numeric` 或 `thuthesis-author-year`，除非同时迁移并测试
这些 biblatex 样式文件。

## 验证

完整 biblatex 行为需要 `.tex + .bib + biber + \printbibliography` 覆盖。
当前入口：

- `testfiles/config-biblatex.lua`: 带 Biber 的 l3build 配置。
- `testfiles/biblatex/biblatex-hook-loading.tex`: 覆盖 `\thusetup[bib]`
  后手动 `\usepackage{biblatex}` 的路径。
- `testfiles/biblatex/biblatex-hook-loading.bib`: 该测试的参考文献数据。

修改 biblatex 载入、选项、样式或资源导入时，至少运行
`l3build check -c testfiles/config-biblatex`。
