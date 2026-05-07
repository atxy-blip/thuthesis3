# Claude Instructions for `thuthesis3`

Follow `AGENTS.md` as the shared project policy. This file exists only for
Claude-specific startup behavior and must not override the repository facts in
`llmdoc/`.

## Startup

Always start with `llmdoc/`: read `llmdoc/startup.md` and follow its reading
order.

If `llmdoc/` is missing, fall back to `README.md` and source comments, then
suggest initializing project memory.

## Local Project Rules

- Treat `thuthesis3` as the final LaTeX3-native rewrite destination.
- Use `atxy-blip/thuthesis2e` as the legacy behavior oracle.
- Use `nju-lug/NJUThesis` as a LaTeX3 mechanism reference only.
- Do not assume local checkout paths from repository names. Read
  `llmdoc/reference/sibling-repositories.md` for the local clone paths on the
  current machine.
- Edit `source/thuthesis3.dtx`, not generated `.cls` or `.def` files.
- Keep behavior changes tied to oracle evidence or an explicit documented
  intentional difference.

## Tools and Agents

Do not assume thuthesis3-specific agents, commands, or skills are available in
this repository. Use the tools actually available in the current environment.

When a workflow mentions an unavailable helper, perform the equivalent local
steps manually while preserving the llmdoc-first rule.

## Language

Use Simplified Chinese for commit messages, `CHANGELOG.md` entries, and public
documentation prose in `source/thuthesis3.dtx`.

For conversation, follow the user's language unless a higher-priority local
preference is provided.

## Documentation Updates

After non-trivial code changes, do not update `llmdoc/` automatically. Ask the
user first, then update only the relevant documents if they confirm.
