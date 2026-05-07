# Agent Instructions for `thuthesis3`

## STEP ONE IS ALWAYS: READ LLMDOC!

Before reading any source code, **ALWAYS check if `llmdoc/` exists** in the project root. If it exists, this is your primary source of truth.

**THIS IS NON-NEGOTIABLE.** Every task, every investigation, every code change MUST start with reading the documentation

### Why llmdoc First?

1. **Efficiency**: Documentation is pre-digested knowledge, faster than parsing code
2. **Context**: Provides architectural understanding that code alone cannot convey
3. **Accuracy**: Maintained by developers, reflects intended design not just implementation

## llmdoc Structure

```
llmdoc/
├── startup.md            # Entry point — exact reading order
├── index.md              # Directory — find the right document
├── overview/             # "What is this project?"
│   └── project-overview.md
├── architecture/         # "How does it work?"
│   └── *.md
├── guides/               # "How do I do X?"
│   └── *.md
└── reference/            # "What are the specifics?"
    └── *.md
```

### Reading Priority

1. **Read `llmdoc/startup.md`** — entry point with exact reading order
2. **Use `llmdoc/index.md`** — find task-specific documents
3. **Read relevant `architecture/` docs** — before modifying related code
4. **Consult `guides/`** — for step-by-step workflows
5. **Check `reference/`** — for conventions, specs, sibling repo paths

## Working with llmdoc

### Before Writing Code

1. Check: does `llmdoc/` exist?
   - YES → read `llmdoc/startup.md` and follow its reading order
   - NO → proceed from `README.md`, source comments, and local tests, and suggest initializing project memory
2. Find relevant architecture docs for the area you're modifying
3. Check guides/ for existing workflows
4. Review reference/ for conventions to follow

## Critical Rule

Edit `source/thuthesis3.dtx`, never generated `.cls` or `.def` files.

## After Completing Code Changes

Documentation updates are not automatic. After completing a task:

1. Identify which concepts/features were affected
2. Ask the user: "Would you like to update the project documentation?"
3. If confirmed, update relevant docs in `llmdoc/`:
   - Modify existing docs to reflect changes
   - Add new docs if new concepts were introduced
   - Keep updates minimal and precise
   - Update `index.md` if document structure changed

Stable project memory belongs in `llmdoc/`. Temporary investigations belong in
`.llmdoc-tmp/`.

### Documentation Update Principles

1. **Minimality**: Use fewest words necessary
2. **Accuracy**: Based on actual code, not assumptions
3. **No Code Blocks**: Reference code with `path/file.ext:line` format
4. **LLM-Friendly**: Write for machine consumption, not human tutorials

## Code Reference Format

When referencing code in documentation or reports:

```
# Good — reference format
`src/auth/jwt.js` (generateToken, verifyToken): Handles JWT creation and validation

# Bad — pasting code
function generateToken(payload) {
  // ... 50 lines of code
}
```

## Quick Reference

| Task               | Action                               |
| ------------------ | ------------------------------------ |
| Understand project | Read `llmdoc/startup.md` → `overview/` |
| Modify feature X   | Read `architecture/` docs first      |
| Follow workflow    | Check `guides/`                      |
| Check conventions  | Read `reference/`                    |
| After code changes | Offer to update relevant docs        |
