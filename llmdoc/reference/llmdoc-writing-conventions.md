# llmdoc Writing Conventions

## 总原则

llmdoc 是给未来维护者和 LLM 使用的工程知识库，不是任务流水账。写入前先
判断知识类型：稳定事实进入 stable docs；一次性调查进入 `.llmdoc-tmp/`；
过程教训进入 `memory/reflections/`；长期决策进入 `memory/decisions/`。

优先写可复用的判断规则、系统边界、验证方法和负面约束。不要把临时命令输出、
未验证猜测、长代码片段或完整 debug 过程塞进 architecture/reference。

## 文件职责

- `startup.md`: 只保存启动阅读顺序和少量任务升级提示。
- `index.md`: 全局路由图，说明每类文档和主要文件的用途。
- `must/`: 每次工作都可能影响判断的仓库级规则。
- `overview/`: 项目身份、范围、顶层结构和当前状态。
- `architecture/`: ownership boundary、runtime flow、状态机、dispatch 模型和
  不变量。
- `guides/`: 一个文件只写一个可执行 workflow。
- `reference/`: 稳定查表事实、命令、fixture matrix、布局契约、编码约定。
- `memory/decisions/`: durable design/process decisions。
- `memory/reflections/`: 任务后反思、失败原因、验证教训和可提升的知识。
- `memory/doc-gaps.md`: 已知文档缺口。

`index.md` 和 `startup.md` 不互相复制。新增文档后必须更新 `index.md`；只有
真的需要 recurring startup 才更新 `startup.md`。

## 拆分粒度

一个文档只承担一种职责。优先按责任、流程或不变量簇切分，而不是按日期或任务
批次切分。

好的拆分信号：

- 文档同时包含架构、命令、fixture 表和 TODO，应拆分。
- 文档超过约 150 行且后续难以定位，应考虑拆分。
- 同一段知识会被多个任务复用，应提升到 architecture 或 reference。
- 只对本次调查有用的中间数据，应留在 `.llmdoc-tmp/` 或 `temp/`。

保留历史导航页可以，但不要再向历史混合文档追加新知识。

## 写法

先写心智模型，再写具体路径或例外。每段应回答“未来任务为什么需要知道这个”。

推荐结构：

- 定位：这个概念负责什么，不负责什么。
- 稳定入口：相关源码、fixture、命令或文档路径。
- 不变量：修改时不能破坏的行为。
- 负面约束：不要采用的修复方向和原因。
- 验证：接受修改前要跑或比较什么。
- 缺口：未完成时写入 status 或 doc-gaps。

少贴代码，多引用位置。文档中的代码引用使用 `path/file.ext`、符号名或简短
路径描述；不要粘贴大段源码。确实需要命令时，只保留最短可复用命令。

## Memory 写法

`decisions/` 写“以后应继续遵守的决定”。文件名优先用主题或 issue，而不是
只有日期。正文至少包含问题、决定、理由和影响范围。

`reflections/` 写“这次为什么绕路，以及下次怎么更快”。可以记录失败路径，
但结尾要提炼可复用教训。反思中的 doc gap 不等于稳定事实；修复后应更新
stable docs 或 `memory/doc-gaps.md`。

不要改写历史 reflection 来追求当前一致性，除非原文事实错误会误导未来任务。
历史引用旧文件名是可接受的；新的路由应通过 `index.md` 和 stable docs 解决。

## Cover 文档约定

封面相关知识按以下入口维护：

- 架构和 dispatch 边界：`architecture/cover-system.md`
- oracle 与 fixture matrix：`reference/cover-oracles-and-fixtures.md`
- 页面几何、字体、bbox 契约：`reference/cover-layout-contracts.md`
- 迁移完成项和剩余项：`reference/cover-migration-status.md`
- 实际 overlay/bbox 流程：`guides/cover-visual-parity.md`
- 结构设计草案：`reference/cover-xtemplate-dispatch-design.md`

不要继续向 `reference/cover-structure-and-todo.md` 追加新知识；它只保留历史
导航作用。
