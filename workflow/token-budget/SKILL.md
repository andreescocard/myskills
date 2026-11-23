---
name: token-budget
description: Spend as few tokens as the task allows. Pick the cheapest model tier that can do the job (work directly, escalate to a heavy agent, or hand to a mechanical agent), explore code cheaply (Grep, outline, then ranged reads), and delegate with a tight brief. Use before a big read, before spawning a subagent, or when a session is getting expensive.
disable-model-invocation: true
user-invocable: true
---

Use this to decide how to do a task cheaply, then do it. Keep the answer short: state the tier and the plan in 3 lines, then act.

## 1. Pick the tier

| Tier | Use it for | Do not use it for |
| --- | --- | --- |
| **Direct** (the session's own model) | Questions, small and normal edits, CLI calls, record keeping, anything you can finish in a few steps | Nothing: it is the default |
| **Heavy agent** (strongest model, e.g. `opus-heavy`) | Unknown-cause debugging, refactors across modules, subtle state or concurrency bugs, performance, security-sensitive code, high-stakes analysis, or a direct attempt that came out wrong | Routine work: it costs several times more |
| **Mechanical agent** (cheapest model, e.g. `haiku-mechanic`) | Exact, mechanical jobs: renames, formatting, boilerplate, "run this and summarize the output" | Anything with a design decision or an unknown cause |

Rules of thumb:
- Escalate, don't retry. If a result fails review, resend once with the feedback, then go up a tier.
- If a whole conversation needs the strong model (architecture, long debugging), say so and let the user switch (plan mode or `/model`) instead of spawning agents for every step.
- One subagent per coherent task, not per file. Every spawn re-reads project context.

## 2. Explore cheaply

Go down this ladder and stop as soon as you have the answer:

1. **Grep with a narrow scope** (a folder, a glob, `files_with_matches` first). Never grep the whole repo for a common word.
2. **Outline** of the file: symbols or headings only (a symbol overview tool, `grep -n "^export\|^function\|^class"`).
3. **Ranged read**: `offset` + `limit` around the lines that matter.
4. **Whole file** only when you are about to edit most of it.

For open-ended "where is X handled?" questions that would take more than ~5 searches, delegate to an Explore-style subagent and ask for the conclusion, not the file dumps.

Never read lockfiles, build output, minified bundles, generated code, or logs whole. Tail or grep them.

## 3. Delegate with a tight brief

Before spawning an agent, check:

- [ ] The task is one coherent unit with a clear "done".
- [ ] The brief names **file paths** and the goal, not file contents. The agent reads for itself.
- [ ] It says what to return: "a 5-line summary: what you found, what you changed (files), what you verified, what is left".
- [ ] It says what not to do (no commits, no scope creep, no new dependencies).
- [ ] You will trust the summary. Do not re-read what the agent already reported unless review finds a problem.

## 4. Keep the main context lean

- Don't paste large outputs back into the conversation. Summarize and point to the file.
- Prefer a purpose-built CLI or a small script that prints a compact summary over reading raw data or API responses.
- When the context passes ~60%, finish the current step, then compact or hand off. Do not start a big read at 80%.
- Don't re-derive what the conversation already established.

## Output

```
Tier: <direct | heavy agent | mechanical agent> — <one-line why>
Plan: <the 1-3 cheapest steps>
```

Then do it.
