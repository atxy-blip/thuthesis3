# Git Commit Style

Use this convention when drafting commits for `thuthesis3`.

## Subject Format

Commit subjects should start with a lowercase type label followed by a colon:

```text
<type>: <简体中文说明>
```

If the commit directly references an issue or pull request, append a GitHub
style reference at the end:

```text
<type>: <简体中文说明> (#1)
```

The issue reference is optional. Use it only when the change is tied to a
specific issue or PR.

## Type Labels

Common labels:

- `feat`: user-visible feature or new supported behavior.
- `fix`: bug fix or compatibility correction.
- `refactor`: internal restructuring without intended behavior change.
- `docs`: documentation-only change.
- `test`: tests or fixtures.
- `build`: build, packaging, or release configuration.
- `ci`: continuous integration workflow.
- `chore`: maintenance that does not fit the categories above.

Prefer the narrowest accurate label. For example, updating llmdoc is `docs`,
while changing `build.lua` packaging behavior is usually `build`.

## Language Rules

Commit subjects and bodies should be written in Simplified Chinese.

Documentation prose inside `source/thuthesis3.dtx` should also be written in
Simplified Chinese, including user-facing explanations and implementation
comments. Keep TeX macro names, option names, file names, and code identifiers
unchanged.

llmdoc files may use English unless the task specifically asks otherwise, but
commit messages and `.dtx` documentation should use Simplified Chinese.

## Body Style

Small commits may use only a subject.

Add a body when the reason is not obvious from the diff, especially for:

- repository policy decisions;
- migration-roadmap changes;
- behavior compatibility decisions;
- test oracle changes;
- architectural LaTeX3 module migrations.

The body should explain why the change exists and what future work should
preserve.

## Examples

```text
docs: 初始化 llmdoc 项目记忆
```

```text
refactor: 使用 l3keys 重写选项解析 (#12)
```

```text
fix: 保持匿名模式下导师信息隐藏 (#18)
```

```text
test: 增加英文封面回归用例
```
