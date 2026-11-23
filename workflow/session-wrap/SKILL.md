---
name: session-wrap
description: Close out a work session cleanly. Lists what was decided and what is still open, shows the uncommitted changes, flags anything left half-done, and asks before committing. Use at the end of a session or before switching tasks. For a handoff to another agent use /handoff instead.
disable-model-invocation: true
user-invocable: true
---

Wrap up the current session in a short report. Do not start new work, and do not commit unless the user says yes at the end.

## 1. Gather (read-only, cheap)

- `git status --short` and `git diff --stat` for what changed. Do not print full diffs.
- `git log --oneline` for the commits made this session, if any.
- Skim the conversation (not the files) for decisions, open questions, and things the user said to do later.

Not a git repo? Skip the git steps and say so.

## 2. Check for loose ends

For each, one line if present, nothing if not:

- **Half-done work**: a TODO you left, a failing or skipped test, a build you did not run.
- **Unverified claims**: something you said works but did not run.
- **Stray files**: scratch files, debug logs, `console.log`/`print` left in code, files that look like secrets (never open them; only flag by name).
- **Follow-ups**: tasks, notes or records the project's instructions say to update after a change.

## 3. Report

```
Done:
  - <what changed, by outcome, not by file>
Decisions:
  - <decision> — <why, in a few words>
Open / next:
  - <pending item>
Working tree: <N files changed, M untracked> (<grouped by area>)
Loose ends: <list or "none">
```

Keep it under ~20 lines.

## 4. Ask

End with exactly one question, in the user's language:

- If the working tree has changes: "Want me to commit? (I'd group it as: ...)"
- If it is clean: "Anything else before we stop?"

Commit only after an explicit yes in this conversation. Never push, amend or tag unless asked for that specifically.
