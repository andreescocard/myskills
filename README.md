<p align="center">
  <img src="https://em-content.zobj.net/source/apple/391/toolbox_1f9f0.png" width="120" />
</p>

<h1 align="center">myskills</h1>

<p align="center">
  <strong>small prompts. useful skills. less repeated thinking.</strong>
</p>

<p align="center">
  <a href="https://github.com/andreescocard/myskills/stargazers"><img src="https://img.shields.io/github/stars/andreescocard/myskills?style=flat&color=yellow" alt="Stars"></a>
  <a href="https://github.com/andreescocard/myskills/commits/main"><img src="https://img.shields.io/github/last-commit/andreescocard/myskills?style=flat" alt="Last Commit"></a>
  <a href="LICENSE"><img src="https://img.shields.io/github/license/andreescocard/myskills?style=flat" alt="License"></a>
</p>

<p align="center">
  <a href="#what-is-this">What is this?</a> •
  <a href="#whats-inside">What's inside</a> •
  <a href="#install">Install</a> •
  <a href="#usage">Usage</a> •
  <a href="#why">Why</a>
</p>

---

A public collection of reusable prompts, command files, checklists, templates, and workflow helpers for coding, debugging, planning, reviewing, and shipping.

Built for real development work:
- investigate faster
- review safer
- repeat less
- keep useful patterns versioned

## What is this?

`myskills` is my reusable toolbox for engineering work.

Not a framework.  
Not a product.  
Not a giant second brain.

Just practical things I actually want to keep:
- prompts
- commands
- review flows
- debugging helpers
- shipping checklists
- templates
- notes worth reusing

## What's inside

Each skill is a folder with a `SKILL.md`. The folder name is the command name.

| Folder | Skills | For |
| --- | --- | --- |
| `workflow/` | `token-budget`, `mem-audit`, `scaffold-cli`, `session-wrap` | Spending fewer tokens and closing work cleanly |
| `general/befable/` | `befablefull`, `befablelite`, `befableplan`, `befablerun`, `befabletest` | Evidence-first execution, planning and verification modes |
| `general/linkedin/` | `linkedinaudit` | Re-runnable LinkedIn profile audit |
| `frontend/angular/` | `ng-safetoship`, `ng-safetoshiplite` | Angular release-safety review |
| `sap-commerce/` | `hybris-safetoship`, `hybris-safetoshiplite`, `hybris-impex-review`, `accelerator-to-spartacus` | SAP Commerce storefront review, ImpEx review, migration scoping |
| `agents/` | `opus-heavy`, `haiku-mechanic` | Subagents for model routing |
| `setup/` | `settings.snippet.json`, `CLAUDE.model-routing.md` | `opusplan` + secret deny rules, and the routing rules to paste |

### Workflow skills

- **`/token-budget`** picks the cheapest model tier that can do the job, gives a Grep → outline → ranged-read ladder for exploring code, and a checklist for delegating with a tight brief.
- **`/mem-audit`** audits `CLAUDE.md`, `MEMORY.md` and memory files for duplicates, stale entries and things the repo already records. It also reports the tokens loaded every session. It applies nothing until you approve.
- **`/scaffold-cli`** builds a thin CLI over an HTTP API (helper + one CLI per domain) so the agent reads 8 compact lines instead of 400 lines of JSON.
- **`/session-wrap`** ends a session: decisions, open items, uncommitted changes, loose ends. Then it asks before committing.

### Review skills

- **`ng-safetoship`** is a strict Angular release-safety review: RxJS cleanup, SSR and browser-only globals, async and error paths, shared-component regressions, rollout risk. **`ng-safetoshiplite`** is the two-minute version.
- **`hybris-safetoship`** is a strict review for SAP Commerce accelerator storefronts: JSP/`.tag` escaping, design-token discipline, multi-storefront parity, build-pipeline sync, impex-seeded CMS mismatches. **`hybris-safetoshiplite`** is the quick pass.
- **`hybris-impex-review`** checks ImpEx for non-idempotent imports, missing keys, unresolved references, locale gaps, catalog-version mistakes and environment-specific values.
- **`accelerator-to-spartacus`** inventories an Accelerator storefront and writes a migration checklist for Spartacus. It is read-only.
- **`linkedinaudit`** audits a LinkedIn profile against today's market and produces a prioritized list of fixes. Re-run it when a new model ships or your role changes.

### Skills I use from others

Not copied here, so you get their updates and the authors keep their licenses. Install them from the source:

- [JuliusBrussee/caveman](https://github.com/JuliusBrussee/caveman): ultra-compressed replies to cut output tokens
- Skills for `grill-me`, `tdd`, `diagnose`, `handoff`, `to-prd`, `to-issues`, `triage` and `review` come from a public skills kit. Search for the one you like with `find-skills`, and install it from its own repository.

## Before / After

<table>
<tr>
<td width="50%">

### Without reusable prompts

> Rebuild the same review logic again.  
> Forget one important check.  
> Miss SSR risk.  
> Ask the model the same thing in five different ways.

</td>
<td width="50%">

### With `myskills`

> Reuse the same prompt.  
> Keep the same review standard.  
> Catch common risks faster.  
> Spend less time rewriting instructions.

</td>
</tr>
</table>

**Same goal. Less repeated thinking.**

## Install

**1. Clone**

```bash
git clone https://github.com/andreescocard/myskills.git
cd myskills
```

**2. Run the installer for your OS**

```bash
# Linux / macOS / Git-Bash
bash install.sh
```

```powershell
# Windows PowerShell
./install.ps1
```

```bat
:: Windows CMD (runs install.ps1)
install.bat
```

Options (the same on every OS; PowerShell spells them `-WithAgents`, `-WithSettings`):

| Option | Effect |
| --- | --- |
| `--with-agents` | Also copies `agents/*.md` to `~/.claude/agents` |
| `--with-settings` | Prints `setup/settings.snippet.json` to merge by hand. It never edits your settings |

Where things go:

| Tool | Location | Form |
| --- | --- | --- |
| Claude Code | `~/.claude/skills/<name>/` | skill folder |
| Codex | `~/.codex/skills/<name>/` | skill folder |
| Cursor | `~/.cursor/commands/<name>.md` | flattened command |

Older versions installed flat commands into `~/.claude/commands` and `~/.codex/prompts`. The installer removes those copies so a skill isn't listed twice.

**3. Use**

Type `/` and the skill name, for example `/token-budget`, `/ng-safetoship` or `/linkedinaudit <profile-url> [apply]`. Skills are explicit-invoke only, so the model won't run them on its own.

New skills are picked up automatically: add a folder with a `SKILL.md` and re-run the installer.

## Usage

Use the files however they fit your workflow.

Examples:
- copy prompts into ChatGPT, Claude, Codex, Cursor, or other tools
- turn them into slash commands (see [Install](#install))
- adapt them into skills
- use them as review checklists
- keep your own fork with project-specific versions

Manual clone:

```bash
git clone https://github.com/andreescocard/myskills.git
```
