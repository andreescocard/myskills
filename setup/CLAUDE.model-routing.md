# Model routing
Goal: minimize token spend. The session model is `opusplan` (settings.json): the strong model in plan mode, the mid-tier model otherwise. The main session is already cheap, so routine work (questions, records, small and normal edits, CLI calls) runs directly, with no subagent.

- Escalate to the `opus-heavy` agent for hard, well-scoped work: unknown-cause debugging, cross-module refactors, subtle state/concurrency bugs, performance, security-sensitive code, or when a cheaper attempt came out wrong. Pass the needed context; it starts cold.
- Use `haiku-mechanic` only for exact mechanical jobs (renames, formatting, boilerplate, run-and-summarize).
- Escalate, don't retry: if a result fails review, resend with feedback once, then go up a tier.
- If a whole conversation needs the strong model (architecture, long debugging), switch to plan mode (Shift+Tab) or `/model opus`.

Token discipline in the main session:
- Don't read whole files into main context to "prepare" a delegation. Pass file paths and a tight task description; let the subagent read.
- Don't re-derive what a subagent already reported; trust its summary unless review finds a problem.
- Prefer Grep with a narrow scope over broad reads. Context-gathering goes to the Explore agent, not inline reads.
- One subagent per coherent task, not per file.
