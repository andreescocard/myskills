---
name: hybris-safetoshiplite
description: Quick Hybris/SAP Commerce accelerator storefront release-safety pass for current changes
disable-model-invocation: true
user-invocable: true
---

Scan the current diff (staged + unstaged against main) for the highest-signal risks only,
for a SAP Hybris responsive JSP storefront (JSP + `.tag` + SCSS, possibly several storefront extensions).
This should take under 2 minutes. Prefer signal over completeness.
Do not flag issues outside the scope of the current diff.

---

Check only for:
- **Multi-storefront parity** — shared JSP/token/SCSS change applied to only one storefront tree; a cloned storefront left stale
- Inline styles (`style="..."`) in JSP/.tag/HTML, or hardcoded hex/font instead of the project's design tokens and typography mixins
- Unescaped CMS/user output → XSS (esp. custom script and JSP include components, raw `${...}`)
- Missing null checks on model/CMS/API data in the view → JSP NPE
- A manually-built theme changed without a rebuild → ships stale; or wrong Node/node-sass version
- Obvious regression in shared tags, addon overrides, or impex-seeded CMS component mismatch

---

Output exactly in this format:

Verdict: Safe to ship / Risky / Needs fixes

Scope:
- what was reviewed (branch, commits, files, which storefronts)

Top risks:
- ...

Multi-storefront parity issues:
- ...

Not reviewed:
- anything out of scope or skipped

Safe to ship: yes / no — short reasoning
