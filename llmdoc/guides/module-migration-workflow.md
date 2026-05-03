# Module Migration Workflow

Use this guide when moving one behavior area from legacy ThuThesis into the
LaTeX3 architecture.

## 1. Classify the Work

Decide whether the work is:

- behavior-preserving cleanup in `../thuthesis2e`;
- LaTeX3 migration experiment in `../thuthesis2e/refactor/*`;
- final implementation in `thuthesis3`.

If the change is architectural, do not merge it back to
`../thuthesis2e/master` just because tests pass.

## 2. Find the Oracle

In `../thuthesis2e`:

- read the relevant part of `thuthesis.dtx`;
- find existing tests under `testfiles/`;
- check `llmdoc/reference/l3build-tests.md` for test layout and commands.

If coverage is missing, add the test to `../thuthesis2e/master` first when that
is practical.

## 3. Compare the Technology Reference

In `../NJUThesis-njulug`:

- read `llmdoc/startup.md`;
- read the relevant architecture or reference doc;
- inspect `source/njuthesis.dtx` only for the matching mechanism.

Useful local patterns include:

- `l3keys` module forwarding;
- filtered key groups;
- `xtemplate` page/element objects;
- hook-based execution phases;
- l3build test organization.

## 4. Implement in `thuthesis3`

Edit `source/thuthesis3.dtx` as the source of truth.

Keep public documentation and implementation aligned when changing user-facing
options, commands, or environments.

For class options specifically, compare against option names in
`../thuthesis2e/master`. Exclude `\thusetup`-only keys and math-style keys
unless the task explicitly asks for them. Use NJUThesis only for LaTeX3
mechanisms, not for the inherited public option list.

Prefer small module-sized ports. Avoid broad mechanical rewrites that combine
options, rendering, fonts, and tests in one change.

## 5. Verify

Run the closest available verification:

- `l3build install` for generated class files;
- compile `docs/thuthesis-example.tex` when the class is installable;
- port or add l3build tests for the module when a test harness exists.

For layout-sensitive pages, treat log tests as necessary but not sufficient.
Use PDF or visual comparison when page geometry matters.

## 6. Update llmdoc

After a non-trivial migration, run the llmdoc update workflow or at least add a
decision/reflection when:

- the module ownership changed;
- behavior intentionally differs from `../thuthesis2e`;
- a reusable migration pattern was discovered;
- a test gap was found.
