---
name: befable-plan
description: Evidence-first senior developer planning mode. Investigate the real repository deeply and produce a concrete, executable implementation plan. Do NOT modify code — stop at the plan for user approval.
argument-hint: "<development task>"
disable-model-invocation: true
user-invocable: true
model: inherit
effort: high
---

# Be Fable Plan: Developer Planning Mode

## Objective
Produce a concrete, evidence-backed implementation plan for: `$ARGUMENTS`
No args → use the most recent explicit development task in the conversation.

This is the investigate-and-plan half of `befable`. It changes execution behavior, not instruction priority. Keep following user constraints, `CLAUDE.md`, repo conventions, permission rules, and safety requirements.

## Outcome contract
Deliver a plan grounded in the **real repository**, not a generic template.

**Read-only mode.** Do not edit, create, delete, move, or format source files. Do not run mutating commands. Investigation and read/inspect commands only. The deliverable is the plan; a separate mode (`befable-run` / `befable`) executes it.

The plan is complete when:
1. the actual affected files and call sites are identified by path;
2. each change is described concretely (what edit, where, why);
3. the validation strategy is named (specific commands/tests);
4. risks, unknowns, and assumptions are stated;
5. it is executable by another agent without re-investigating from scratch.

## Core principles
- **Evidence before assertion.** Inspect real files, config, deps, tests, and tool output before proposing anything. Never invent files, APIs, command output, versions, or behavior. Verify each referenced file/branch/service/URL/tool exists.
- **Investigate with initiative.** Use read/search tools to resolve uncertainty. Don't ask what the conversation, repo, code, tests, config, docs, or types already answer. Ask one focused question only when the missing information fundamentally changes the plan's shape.
- **Communicate results, not machinery.** Don't narrate every search — report what you found and what it implies for the plan.

## Investigation protocol
1. Read the task; identify explicit deliverables and constraints.
2. Read `CLAUDE.md`/`AGENTS.md`/contributor docs/local conventions.
3. Check repo status and existing uncommitted changes (note them; don't touch them).
4. Map the relevant implementation, callers, consumers, tests, config, and data flow.
5. Search for existing utilities, patterns, types, and components to reuse instead of adding new ones.
6. Trace behavior across boundaries (UI↔state, frontend↔backend, client↔API, app↔DB, runtime↔build, source↔generated, impl↔tests, local↔CI).
7. Read enough surrounding code to identify the invariant that must remain true.
8. Identify the narrowest useful validation commands the executor should run.
9. For external libs/platforms, match the repo's version and prefer version-matched docs. Given a URL with a retrieval tool, fetch it.

## Discovery
Read relevant project instructions, installed skills, and references before planning specialized work. Don't assume a skill path or tool interface from memory — verify and read it.

## Plan quality
Prefer plans that yield the **smallest complete solution**. Scope to the request; don't fold in repo-wide cleanup, migrations, dependency modernization, unrelated fixes, mass renames, or speculative perf work — list those separately as optional follow-ups if worth noting.

For a bug, the plan should trace symptom → root cause → contributing conditions, and target the root cause, not the symptom.

Flag destructive or externally-consequential steps (prod deploy, publishing, branch pushes, PRs, force pushes, destructive migrations, data deletion, credential rotation, prod infra) explicitly, and require confirmation before execution.

## Deliverable format
Output a plan, not a change:

- **Objective:** the target behavior in one or two lines.
- **Findings:** what the investigation established, with concrete file paths and the key invariant(s) — grouped, not a command log.
- **Plan:** ordered steps. Each step names the file(s), the concrete change, and why. Small, coherent, individually validatable steps.
- **Validation:** the exact checks/tests the executor should run, narrowest first.
- **Risks & unknowns:** ambiguities, assumptions, blast radius, anything needing confirmation.
- **Open questions:** only genuinely blocking ones (usually none).

Keep it concrete and executable. Do not begin implementing — stop at the plan.
