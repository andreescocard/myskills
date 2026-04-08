---
description: Quick release-safety pass for current changes
---

Scan the current diff (staged + unstaged against main) for the highest-signal risks only.
This should take under 2 minutes. Prefer signal over completeness.
Do not flag issues outside the scope of the current diff.

---

Check only for:
- Uncleaned subscriptions, listeners, or timers → memory leaks
- Unsafe access to window, document, localStorage, navigator, etc. in SSR-sensitive code → SSR crashes
- Missing null checks on API or backend data → runtime exceptions
- Broken async, loading, or error handling → dead-end UI or silent failures
- Obvious regressions in shared or reused components

---

Output exactly in this format:

Verdict: Safe to ship / Risky / Needs fixes

Scope:
- what was reviewed (branch, commits, files)

Top risks:
- ...

SSR issues:
- ...

Memory leak issues:
- ...

Not reviewed:
- anything out of scope or skipped

Safe to ship: yes / no — short reasoning
