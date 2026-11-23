---
name: scaffold-cli
description: Generate a thin command-line client over an existing HTTP API so the agent reads compact summaries instead of raw JSON, database rows or whole endpoints. Produces a shared helper (api call, flag parser, id-prefix resolver, error wrapper) plus one small CLI per domain. Use when the same API or data keeps being read in full, or before building any "look at the data" workflow.
argument-hint: "<API base URL or OpenAPI/route folder> [domain to start with]"
disable-model-invocation: true
user-invocable: true
---

A purpose-built CLI turns "read 400 lines of JSON" into "read 8 lines of text". It also gives the agent one safe, documented way to write data. Build it once, then point the project's instructions at it.

## 1. Learn the API (cheaply)

- Read the route list or OpenAPI file, not every handler. Grep route registrations; read one or two handlers for shape.
- Pick **one domain** to start (tasks, orders, customers...). Do not wrap the whole API.
- Note: base URL (env var, with a local default), auth method (env var only), response envelope (`{ data }`, `{ error }`), and the id format.

Never read `.env*` or credential files to find the base URL or a token. Use an env var name and ask the user to set it.

## 2. Check the runtime

Use what the project already has (`package.json`, `pyproject.toml`). Default to the project's existing language and package manager; one dependency-free file is better than a framework. The examples below are TypeScript on a runtime with `fetch`; translate as needed.

## 3. Generate the shared helper (`scripts/lib/cli.ts`)

It exports exactly these, and nothing else:

```ts
export const BASE_URL = (process.env.APP_API_URL ?? 'http://localhost:3000').replace(/\/$/, '')
export class CliError extends Error {}
export const out = (text: string) => process.stdout.write(`${text}\n`)
export const fail = (message: string): never => { throw new CliError(message.replace(/\s+/g, ' ').trim()) }

// api<T>(path, init): fetch + JSON envelope. Network failure -> CliError("API offline: start it with ...").
//   Non-2xx -> fail(`error ${status}: ${message}`). Returns json.data.
// parseArgs(argv): { positional: string[], flags: Record<string, string | true> }.
//   `--name value`, or a bare `--name` (boolean) when the next token is another flag or the end.
// resolveByPrefix(items, prefix): the single item whose id starts with prefix.
//   Zero or several matches -> fail with the short ids so the caller can retry.
// runCli(main): runs main(argv), prints CliError messages to stderr without a stack, sets exit code 1.
```

Rules:
- Output is **plain text, one line per record**, short ids (first 8 chars), no colors, no tables wider than ~100 columns.
- Errors are one line. No stack traces.
- Auth comes from an env var, never a flag, never printed.

## 4. Generate one CLI per domain (`scripts/<domain>.ts`)

Subcommand set, only what the domain needs:

```
<domain> ls [--filter ...]      # compact list, newest first, capped (default 20) with "N more"
<domain> show <id-prefix>       # one record, key: value lines
<domain> add "title" [--flag v] # create; prints the new short id
<domain> set <id-prefix> key=value ...   # partial update; `key=-` clears a field
<domain> done|rm <id-prefix>    # state changes the domain really has
```

Add a `--json` flag only where another program consumes the output. Add a `--short` summary mode for the command the agent will call most (the "what's up today" view).

## 5. Wire it in

1. Add a script entry per CLI to the project's task runner (e.g. `package.json`: `"tasks": "bun scripts/tasks.ts"`).
2. Add a short block to the project's instructions file:

```
### Domain CLIs (prefer these over reading the DB or calling the API raw)
<one example line per subcommand>
```

3. Smoke-test: run `ls`, `show` on the first id, and one write against a safe or test record. If the API is not running, say so rather than guessing the output.

## Output

List the files created, the commands added to the instructions, and the smoke-test result. Do not commit.
