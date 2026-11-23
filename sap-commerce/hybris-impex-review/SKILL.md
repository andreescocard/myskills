---
name: hybris-impex-review
description: Review ImpEx files in the current changes for SAP Commerce (Hybris) for data-safety and import-correctness problems: wrong modes, missing keys, unresolved references, locale gaps, catalog version mistakes, and non-idempotent imports. Use before merging or running any ImpEx on a shared environment.
argument-hint: "[git range or file paths] — optional; defaults to the diff against main"
disable-model-invocation: true
user-invocable: true
---

Review the ImpEx files in scope (`*.impex`, including ImpEx embedded in Java or Groovy strings). Default scope: the current branch diff against main plus any untracked `.impex` files. State the scope you actually reviewed.

Focus on what can corrupt data or fail on import. Do not flag style nits. Do not run the import.

## Checks

**Idempotence and mode**
- `INSERT` used for data that already exists on a re-run (duplicates or a unique-constraint failure). Prefer `INSERT_UPDATE` with a complete unique key.
- `UPDATE` on rows that may not exist (silently does nothing).
- `REMOVE` present: flag it as destructive and ask who runs it where. It must be explicit in the report.
- Re-running the file twice must give the same result. If it cannot, say why.

**Keys and references**
- Every `[unique=true]` column together identifies exactly one row. A missing part of a composite key (for example `catalogVersion` on a catalog-aware type) means rows overwrite each other.
- References resolve in the same file or in a file that is guaranteed to run before it (check the order in the project's `initialdata`/`essentialdata` or the import list).
- `$macros` are defined before use and not shadowed. A macro that sets `catalogVersion(catalog(id),version)` is applied to every catalog-aware line.
- Header and value columns line up: same column count, no stray `;`, quoted values with `;` inside, multi-line values closed.

**Catalog and locale**
- `Staged` vs `Online` is intended. Content written straight to `Online` skips the approval and sync flow. Say so.
- Localized attributes (`name[lang=en]`) cover every language the storefront serves. A missing language shows an empty string or the fallback.
- Item types and attributes exist in the project's `*-items.xml` (grep it; do not guess). A renamed or removed attribute fails the whole line.

**CMS and search**
- CMS components, slots and `ContentSlotForPage` rows are attached to the correct `ContentCatalog` and page template. An orphan component never renders.
- Restrictions and `uid`s are unique and follow the project's naming pattern.
- Solr: facet and index property changes need a full re-index. Flag them.

**Environment safety**
- No environment-specific values: URLs, hostnames, emails, passwords, API keys or tokens. These belong in properties, never in a repository ImpEx. Flag by file and line; do not echo the value.
- Test or sample data is not under a path that production runs (`essentialdata`, `projectdata` vs `sampledata`).
- Large imports: flag file sizes that suggest minutes of locking, and updates that touch every product.

**Rollout**
- Does the change need a system update, a restart, a re-index or a catalog sync? List it.
- Is there a way back (a reverse `INSERT_UPDATE`, a backup of the affected rows, or an explicit "no rollback")?

## Output

```
Verdict: Safe to import / Risky / Needs fixes

Scope: <files reviewed>

Blocking:
- <file>:<line> — <problem> → <fix>

Risks:
- ...

Needs a manual step: <system update | re-index | catalog sync | none>

Not reviewed: <anything skipped, e.g. generated files, files over N lines>
```
