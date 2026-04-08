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
  <a href="LICENSE"><img src="https://img.shields.io/github/license/YOUR_USERNAME/myskills?style=flat" alt="License"></a>
</p>

<p align="center">
  <a href="#what-is-this">What is this?</a> •
  <a href="#whats-inside">What's inside</a> •
  <a href="#example-skills">Example skills</a> •
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

Depending on how the repo grows, it may include folders like:

- `commands/` — reusable command-style prompts
- `prompts/` — investigation and implementation prompts
- `checklists/` — review and validation helpers
- `templates/` — reusable Markdown templates
- `notes/` — short references for recurring tasks

## Example skills

### `safetoship.md`

A stricter release-safety review prompt.

Checks things like:
- production risks
- regressions
- memory leaks
- SSR breaks
- unsafe browser API usage
- missing cleanup
- runtime edge cases
- whether the change is actually safe to ship

### `safetoshiplite.md`

A lighter and faster version.

Good for:
- quick risk scan
- short verdict
- top issues only
- fast review before merging

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

## Usage

Use the files however they fit your workflow.

Examples:
- copy prompts into ChatGPT, Claude, Codex, Cursor, or other tools
- turn them into Claude Code slash commands
- adapt them into skills
- use them as review checklists
- keep your own fork with project-specific versions

Clone and adapt:

```bash
git clone https://github.com/YOUR_USERNAME/myskills.git
