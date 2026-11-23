---
name: mem-audit
description: Audit the persistent instruction and memory files (CLAUDE.md, AGENTS.md, MEMORY.md and the memory files it indexes) for duplicates, stale entries, things the repo already records, and fixed token cost per session. Reports what to cut and, only after approval, applies it. Use when sessions feel heavy to start, or every few weeks.
argument-hint: "[path to a memory folder or instruction file] — optional; auto-detects"
disable-model-invocation: true
user-invocable: true
---

Everything in these files is re-read at the start of **every** session, so each wasted line is paid for again and again. This skill finds the waste. It never edits anything until the user approves.

## 1. Find the files

If an argument was given, use it. Otherwise look for, in this order:

- global instructions: `~/.claude/CLAUDE.md` and anything it `@`-imports
- project instructions: `CLAUDE.md`, `.claude/CLAUDE.md`, `AGENTS.md` in the working tree
- the memory index `MEMORY.md` and the memory files it points to (usually next to the project's Claude data folder)

Only read instruction and memory files. **Never open secret files** (`.env*`, keys, credentials) even if a memory mentions them.

## 2. Measure

For each file: lines, characters, and a rough token estimate (chars / 4). Print a table sorted by size and a total: "loaded every session: ~N tokens". The memory index is loaded whole, so flag any index line longer than ~150 characters.

## 3. Check each entry against these tests

| Finding | How to detect it | Action |
| --- | --- | --- |
| **Duplicate** | Same rule or fact in two files, or twice in one | Keep the shortest, most specific copy |
| **Repo already records it** | It states something readable from the code, config, README or git history (commands, folder layout, dependency names) | Delete; the agent can look it up |
| **Stale** | It names a file, flag, function, person, date or version. Verify with a quick Grep or `ls`. Dated facts in the past ("until March") | Delete or fix; mark "unverified" if you cannot check |
| **Contradiction** | Two entries disagree | Ask the user which one is true |
| **Too long** | A rule needs a paragraph | Rewrite as one line: the rule, then why, then how to apply |
| **Enforced elsewhere** | A rule a hook, a permission rule or a linter already enforces | Shrink to one line (the why), keep the enforcement |
| **Misfiled** | A project fact in the global file, or a personal preference in a shared repo file | Move |
| **Orphan** | A memory file the index does not list, or an index line whose file is missing | Add or remove the line |

## 4. Report

```
Loaded every session: ~N tokens (global X, project Y, memory index Z)

Cut/merge (saves ~M tokens):
  1. <file>:<line> — <why> — <proposed change>
  ...
Needs your call:
  - <contradiction or doubtful fact>
Keep as is: <count> entries
```

Order by tokens saved. Quote at most one short line per finding; do not paste whole files.

## 5. Apply

Ask: "Apply all, some, or none?" Apply only what was approved. Keep the user's wording where you keep an entry. Do not commit; leave the changes for the user to review.
