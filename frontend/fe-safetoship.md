---
description: Strict release-safety review for current changes
---

Review the current branch diff against main (staged + unstaged changes and all impacted files).
If scope is ambiguous, state what was actually reviewed in the `Scope` field below.

Goal:
Determine whether the current work is safe to ship, with emphasis on real production risks over generic feedback.
Do not flag issues clearly outside the scope of the current diff.
Do not assume code is safe just because it compiles.

---

Checks to perform:

**Memory & cleanup**
- RxJS subscriptions use takeUntilDestroyed or equivalent
- setTimeout / setInterval / requestAnimationFrame are cleared on teardown
- Event listeners and observers (ResizeObserver, IntersectionObserver, MutationObserver) are removed on destroy
- No retained references that prevent garbage collection

**SSR safety**
- No direct access to window, document, localStorage, sessionStorage, navigator, or other browser-only globals in SSR-sensitive code
- All browser-only logic is guarded (isPlatformBrowser or equivalent)
- No hydration or first-render mismatches
- No code that can break server rendering

**Runtime correctness**
- Null / undefined checks for all API, CMS, and backend data
- Async race conditions and cancellation handled
- Error paths return meaningful state — no silent failures or dead-end UI
- Loading and empty states are covered — no blank screens
- No broken navigation, click handling, or form submission

**Behavioral correctness**
- No accidental regressions in shared or reused components
- No hidden CMS / environment dependency that can break in staging or other envs
- Auth checks, route guards, and role-based access are intact
- No debug logs, console statements, or dev-only code left in

**Frontend impact**
- No obvious bundle size regression (especially from new imports or dependencies)
- No CSS or layout regressions in shared components
- No breaking changes to API contracts (payload shape, removed or renamed fields)
- No risky third-party dependency bumps (major version upgrades, lockfile changes)

**Rollout risk**
- Feature flags, config values, and CMS dependencies are safe for all envs
- Tests cover the risky or changed paths
- No fragile code that requires a specific rollout order or manual step

---

Output exactly in this format:

Verdict: Safe to ship / Risky / Needs fixes

Scope:
- what was reviewed (branch, commits, files)

Blocking issues:
- [issue] → suggested fix

Non-blocking risks:
- ...

SSR risks:
- ...

Memory leak risks:
- ...

Recommended manual checks:
- ...

Not reviewed:
- anything explicitly out of scope or not inspected

Final recommendation:
- yes / no
- short reasoning
