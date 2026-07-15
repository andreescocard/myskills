---
description: Strict Hybris/SAP Commerce accelerator storefront release-safety review for current changes
---

Review the current branch diff against main (staged + unstaged changes and all impacted files)
for a SAP Hybris / Commerce accelerator **responsive JSP** storefront (JSP + `.tag` + SCSS,
gulp/webpack build, dual US/AU storefront extensions).
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
- Extra scrutiny on injection-surface components: `customscriptcomponent.jsp`, `jspincludecomponent.jsp`, any component that emits author-supplied HTML/script
- Tag attributes and required params are provided; no NPE from missing `${}` model attributes
- No broken JSTL logic (`c:if`/`c:choose` conditions, iteration over possibly-null lists)

**Styling / SCSS + design tokens**
- No hardcoded hex colors or font families — use `$rf-loyalty-*` color vars and `rf_loyalty_body1/2/3` mixins / `$rf-loyalty-font-sans|-serif`; only exception is pure-effect rgba (box-shadow/shimmer) with no brand intent
- New SCSS imported in the correct entry (`index.scss` / `components.scss` / R2 `<component>.scss`); watch import ordering (index imports clarity-design-system — don't worsen the duplicate-import smell)
- No layout/regression risk to shared `libs/` or `clarity-design-system` partials from a local override
- Responsive breakpoints via `include-media`; verify mobile + desktop, not just one

**US / AU dual-storefront parity** *(highest-signal check)*
- If a **shared** JSP/.tag class or markup changed, the matching `<component>.scss` was mirrored in **both** FE-Develop trees (`rodanandfieldsstorefront` **and** `rodanandfieldsaustorefront`)
- AU JSP is a divergent clone, not identical — a US-side markup/token fix may not exist AU-side; confirm the AU equivalent was located and updated (or explicitly N/A)
- Message keys / locale content updated for all locales: US `base_en` + `es-us`, AU `base_en`

**Build system correctness**
- Know which of the 3 pipelines the change touches: R2 (gulp/webpack1, auto-syncs to `_ui/dest`), legacy `ACC.*`/jQuery vendor bundle, or **blue theme** (webpack3 — must be manually rebuilt via `rebuild-ui.bat`, does NOT auto-sync)
- A blue-theme SCSS/JS change is accompanied by a rebuild step or note, else it ships stale
- No reliance on wrong Node version — node-sass 4.x build requires Node 10.23.3; don't introduce deps that break it
- No new dependency that breaks the old-browser matrix (autoprefixer targets `ie > 9`)

**Runtime / behavioral correctness**
- Null / undefined guards for all model, CMS, and API data used in the view
- No debug output, `console.log`, commented dead markup, or dev-only blocks left in
- No accidental regression in shared components, tags, or addon overrides (`smarteditaddon`, `paypaladdon`, klarna, assistservice) — check addon override order/precedence
- CMS component markup still matches its impex-seeded component type (fields/typecode); FE change doesn't silently mismatch `*initialdata` impex
- Giant JSPs edited with care (`rfcategoryproductcarouselcomponent.jsp` ~140KB, `rfaddtocartproductcarouselcomponent.jsp`, `rfcardfixedcomponent.jsp`) — localized change, no unintended structural break

**Rollout / assets**
- `_ui/dest` output is unhashed flat files — confirm cache-busting / `_ui` versioning so users don't get stale `app.js`/CSS
- No secret, key, or env-specific value introduced into FE source (tokens, endpoints reference by property name only)
- SmartEdit editability preserved (component slots/contract intact) where relevant

---

Output exactly in this format:

Verdict: Safe to ship / Risky / Needs fixes

Scope:
- what was reviewed (branch, commits, files, US and/or AU)

Blocking issues:
- [issue] → suggested fix

US/AU parity risks:
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
