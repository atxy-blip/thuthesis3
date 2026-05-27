# Cover Oracles and Fixtures

## Oracle 仓库

旧版行为 oracle 是 `C:\Users\admin\Documents\Source\thuthesis2e`。新版实现
仓库是 `C:\Users\admin\Documents\Source\thuthesis3`。相关路径的权威记录见
`reference/sibling-repositories.md`。

封面 parity 的主要 fixture 根目录：

- 2e oracle: `C:\Users\admin\Documents\Source\thuthesis2e\testfiles\01-title-page`
- 3 implementation: `C:\Users\admin\Documents\Source\thuthesis3\testfiles\01-title-page`

English-main 旧版补充 oracle 在
`C:\Users\admin\Documents\Source\thuthesis2e\testfiles\01-title-page-en`；
`thuthesis3` 还没有导入对应 fixture tree。

## 2e Cover Coverage

`thuthesis2e/testfiles/01-title-page` 有 29 个 fixture：

- 3 bachelor cases
- 10 doctor Chinese-cover cases
- 2 doctor English-cover cases
- 8 master Chinese-cover cases
- 3 master English-cover cases
- 2 postdoc cases
- 1 proposal cover case

`thuthesis2e/testfiles/01-title-page-en` 有 30 个 fixture，覆盖 English-main
Chinese cover 和 isolated English cover 的 academic/professional doctor/master
矩阵。

## 3 Fixture Surface

`thuthesis3/testfiles/01-title-page` 当前镜像 2e 的 29 个 title-page fixture。
这些 fixture 的目标不是完整 user workflow，而是隔离 page instance surface：

- bachelor fixtures call `cover-u`
- graduate Chinese and proposal fixtures call `cover-g-zh`
- graduate English fixtures call `cover-g-en`
- postdoc report fixture calls `cover-p-a`
- postdoc title-page fixture calls `cover-p-b`

`testfiles/config-title-page.lua` 已把 proposal 纳入活动测试列表。活动 fixture
仍在扩展中；secret、English-main、engineering-master 和剩余 postdoc parity
需要继续补齐。

## Variant Axes

graduate Chinese cover 主要轴：

- `degree=doctor` vs `degree=master`
- `degree-type=academic` vs `degree-type=professional`
- `thesis-type=thesis` vs `thesis-type=proposal`
- discipline vs professional-field vs engineering-field
- supervisor、associate-supervisor、co-supervisor
- secret-level、secret-year
- `language=english` 时 Chinese cover 仍存在，并包含英文标题

graduate English cover 主要轴：

- doctor/master 决定 Dissertation/Thesis wording
- academic/professional 决定 discipline/professional-field 信息
- supervisor、associate-supervisor、co-supervisor label/value 组合
- English date formatting

postdoc 主要轴：

- report cover: title、author、start-date、end-date、date
- title page: title、title*、author、discipline-level-1、discipline-level-2、
  start-date、end-date、date

## First Parity Targets

优先用小 fixture 建立 bbox parity，再扩展到矩阵：

- graduate Chinese: `01-title-page-doctor-1-1.tex`
- graduate English: `01-title-page-doctor-2-1.tex`
- postdoc report cover: `01-title-page-postdoc-1.tex`
- postdoc title page: `01-title-page-postdoc-2.tex`

doctor academic Chinese cover 的既有 bbox parity 目标见
`reference/cover-layout-contracts.md`。实际对比步骤见
`guides/cover-visual-parity.md`。
