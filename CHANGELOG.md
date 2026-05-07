# thuthesis3 修订记录

本项目发生的用户可见变动和重要架构变动会记录于本文档。

本文档格式参考《[更新日志]》，版本号采用《[语义化版本]》。在首次公开发布
前，所有条目先记录在「未发布」一节；发布时再移动到对应版本号下。

## [未发布]

### 新增

- 继承 ThuThesis 已实现的文档类选项。
- 继承 ThuThesis 已实现的个人信息选项。
- 使用 LaTeX 钩子机制构架封面页执行逻辑
- 使用 `xtemplate` 面向对象构建封面页绘制框架
- 将学术型和专业型学位拆分为两个独立配置文件

### 变动

- 使用新版 LaTeX3 键分组过滤接口，并统一 `\thusetup` 可选键路径处理。

### 杂项

- 初始化 `llmdoc` 项目记忆。
- 记录文档类选项继承规则：选项名称以 `thuthesis2e/master` 为准，
  NJUThesis 仅作为 LaTeX3 实现机制参考。

[更新日志]: https://keepachangelog.com/zh-CN/1.1.0/
[语义化版本]: https://semver.org/lang/zh-CN/
