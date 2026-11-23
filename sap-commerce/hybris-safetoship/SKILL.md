---
name: hybris-safetoship
description: Strict Hybris/SAP Commerce accelerator storefront release-safety review for current changes
disable-model-invocation: true
user-invocable: true
---

Review the current branch diff against main (staged + unstaged changes and all impacted files)
for a SAP Hybris / Commerce accelerator **responsive JSP** storefront (JSP + `.tag` + SCSS,
gulp/webpack build, possibly several storefront extensions that share markup).
If scope is ambiguous, state what was actually reviewed in the `Scope` field below.

Goal:
Determine whether the current work is safe to ship, with emphasis on real production risks over generic feedback.
Do not flag issues clearly outside the scope of the current diff.
Do not assume markup is safe just because the page renders locally.

---

Checks to perform:

**Templating (JSP / .tag / JSTL)**
- No inline styles — no `style="..."` on any JSP/.tag/HTML element; styling must be a class + component SCSS
- User/CMS-authored output is escaped (`c:out` / `fn:escapeXml` / `spring:escapeBody`); no raw `${...}` echoing untrusted content
- Extra scrutiny on injection-surface components: custom script components, JSP include components, any component that emits author-supplied HTML/script
- Tag attributes and required params are provided; no NPE from missing `${}` model attributes
- No broken JSTL logic (`c:if`/`c:choose` conditions, iteration over possibly-null lists)

**Styling / SCSS + design tokens**
- No hardcoded hex colors or font families — use the project's design-token variables and typography mixins; only exception is pure-effect rgba (box-shadow/shimmer) with no brand intent
- New SCSS imported in the correct entry file for its build pipeline; watch import ordering and don't add duplicate imports
- No layout/regression risk to shared libs or design-system partials from a local override
- Responsive breakpoints through the project's breakpoint helper (e.g. `include-media`); verify mobile + desktop, not just one

**Multi-storefront parity** *(highest-signal check, when the repo has more than one storefront extension)*
- If a **shared** JSP/.tag class or markup changed, the matching component SCSS was mirrored in **every** storefront tree that uses it
- A second storefront's JSP may be a divergent clone, not identical — a fix on one side may not exist on the other; confirm the equivalent was located and updated (or explicitly N/A)
- Message keys / locale content updated for every locale of every affected storefront

**Build system correctness**
- Know which pipeline the change touches (e.g. gulp/webpack that auto-syncs to the `_ui` output, a legacy `ACC.*`/jQuery vendor bundle, or an older theme that must be rebuilt manually). Confirm which ones need a manual rebuild
- A change to a manually-built theme is accompanied by a rebuild step or note, else it ships stale
- No reliance on the wrong Node version (e.g. node-sass builds pin an old Node); don't introduce deps that break it
- No new dependency that breaks the supported browser matrix (autoprefixer targets)

**Runtime / behavioral correctness**
- Null / undefined guards for all model, CMS, and API data used in the view
- No debug output, `console.log`, commented dead markup, or dev-only blocks left in
- No accidental regression in shared components, tags, or addon overrides (SmartEdit, payment and assisted-service addons) — check addon override order/precedence
- CMS component markup still matches its impex-seeded component type (fields/typecode); FE change doesn't silently mismatch the `*initialdata` impex
- Very large JSPs edited with care: localized change, no unintended structural break

**Rollout / assets**
- Built `_ui` output is often unhashed flat files — confirm cache-busting / `_ui` versioning so users don't get stale JS/CSS
- No secret, key, or env-specific value introduced into FE source (tokens, endpoints reference by property name only)
- SmartEdit editability preserved (component slots/contract intact) where relevant

---

Output exactly in this format:

Verdict: Safe to ship / Risky / Needs fixes

Scope:
- what was reviewed (branch, commits, files, which storefronts)

Blocking issues:
- [issue] → suggested fix

Multi-storefront parity risks:
- ...

Non-blocking risks:
- ...

Build/asset risks:
- ...

Recommended manual checks:
- ...

Not reviewed:
- anything explicitly out of scope or not inspected

Final recommendation:
- yes / no
- short reasoning
