---
description: Quick Hybris/SAP Commerce accelerator storefront release-safety pass for current changes
---

Scan the current diff (staged + unstaged against main) for the highest-signal risks only,
for a SAP Hybris responsive JSP storefront (JSP + `.tag` + SCSS, dual US/AU).
This should take under 2 minutes. Prefer signal over completeness.
Do not flag issues outside the scope of the current diff.

---

Check only for:
- **US/AU parity** — shared JSP/token/SCSS change applied to only one storefront tree (`rodanandfieldsstorefront` vs `rodanandfieldsaustorefront`); AU clone left stale
- Inline styles (`style="..."`) in JSP/.tag/HTML, or hardcoded hex/font instead of `$rf-loyalty-*` tokens / `rf_loyalty_body*` mixins
- Unescaped CMS/user output → XSS (esp. `customscriptcomponent.jsp`, `jspincludecomponent.jsp`, raw `${...}`)
- Missing null checks on model/CMS/API data in the view → JSP NPE
- Blue-theme change not rebuilt (`rebuild-ui.bat`) → ships stale; or wrong Node/node-sass break
- Obvious regression in shared tags, addon overrides, or impex-seeded CMS component mismatch

---

Output exactly in this format:

Verdict: Safe to ship / Risky / Needs fixes

Scope:
- what was reviewed (branch, commits, files, US and/or AU)

Top risks:
- ...

US/AU parity issues:
- ...

Not reviewed:
- anything out of scope or skipped

Safe to ship: yes / no — short reasoning
