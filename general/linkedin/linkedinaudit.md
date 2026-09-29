---
name: linkedin-audit
description: Audit a LinkedIn profile against today's hiring market and produce a prioritized, ready-to-paste list of fixes; optionally apply them in the browser. Re-run whenever the market, your role, or the model you use changes.
argument-hint: "<linkedin profile url or slug> [apply]"
disable-model-invocation: true
user-invocable: true
model: inherit
---

# LinkedIn profile audit

Target: `$ARGUMENTS` (a profile URL such as `https://www.linkedin.com/in/<slug>/` or just `<slug>`).
If the word `apply` is present, run step 4 after the report; otherwise stay read-only.

Every run judges the profile against **today's** market, not against the last run's advice.
That is the point of re-running it: a newer model, a new job, or a shifted market gives a sharper pass.

## 0. Requirements

- A browser the agent can drive with the user's logged-in LinkedIn session
  (e.g. [browser-harness](https://github.com/browser-use/browser-harness), Playwright/CDP against the user's Chrome).
- Profile content must come from the live page. If a login wall appears, stop and ask the user to log in.
- If no browser tool exists, ask the user to paste the profile text (or a "Save to PDF" export) instead.

## 1. Capture (read-only)

Open the profile tab (reuse an existing one if open), scroll to the bottom in steps so lazy sections load,
then extract `main.innerText` plus the list of `section h2` headings.

Example with browser-harness:

```python
import time, datetime, os
PROFILE = "linkedin.com/in/<slug>"          # from $ARGUMENTS
OUT = "./linkedin-snapshots"                # local, never commit or publish
t = [x for x in cdp("Target.getTargets")["targetInfos"] if x["type"] == "page" and PROFILE in x["url"]]
switch_tab(t[0]["targetId"]) if t else (new_tab("https://www." + PROFILE + "/"), wait_for_load())
for _ in range(12):
    js("window.scrollBy(0, 1500)"); time.sleep(0.6)
txt = js("(document.querySelector('main')||document.body).innerText")
sections = js("JSON.stringify([...document.querySelectorAll('section h2')].map(h=>h.innerText.trim()).filter(Boolean))")
os.makedirs(OUT, exist_ok=True)
path = f"{OUT}/{datetime.datetime.now():%Y-%m-%d_%H%M}.txt"
open(path, "w", encoding="utf-8").write(txt + "\n\n=== SECTIONS ===\n" + sections)
print(path)
```

Diff against the most recent previous snapshot in `./linkedin-snapshots/` if one exists.
Ignore noise: analytics, "People you may know", ads, footer, language picker, other people's posts.

## 2. Check (score each: OK / Adjust / Missing)

**Positioning consistency** — headline, About, current role, Open-to-work titles and top skills must tell ONE story.
- Headline keywords match what the *current* role actually uses (flag tech claimed in the headline but absent from the current job).
- Open-to-work titles don't dilute the niche (e.g. a generic "PHP developer" next to a senior specialist headline).
- Years of experience in About are arithmetically consistent with Experience dates.
- Certifications appear in headline/About; flag any expiring within 6 months.

**Sections present** — Featured, Top skills (all 5 filled), Skills, Projects, Languages (with proficiency), Recommendations, Certifications, Education. Flag missing ones. Flag high-school education on senior profiles.

**Experience bullets** — each role: action + tech + measurable result. Flag vague outcomes ("faster", "improved") without numbers, roles with only 1–2 skill tags, and bullets that duplicate About.

**Market freshness (re-evaluate every run)** — web-search current hiring trends for the user's niche and current AI-assisted development tooling. Check whether the profile mentions the tools and versions recruiters search for *now*. Only suggest a tool if the user plausibly uses it; ask when unsure. Never invent experience.

**Activity** — date of the last *original* post (reposts don't count). Over 3 months → suggest one post idea tied to real work.

**Language** — profile language vs content language; for international roles suggest a secondary-language profile or matching primary language.

## 3. Report

Answer in the user's language:
1. **Changes since last snapshot** (short; skip on first run).
2. **Priority fixes** — table: # / Section / Problem / Fix.
3. **Nice to have**.
4. **Ready-to-paste rewrites** for every section marked Adjust (headline ≤ 220 chars, About ≤ 2,600 chars).

Rules: never fabricate metrics, employers, tools or dates — use `[X]` placeholders for numbers only the user knows.
Don't quote third parties from the feed. Keep snapshots local.

## 4. Apply (only with `apply` or explicit user confirmation)

Confirm the scope (which sections) and ask the user to disable "Share profile updates with your network" if they want a quiet edit.
Edit one section at a time, verify on the live profile after each save, then take a new snapshot.

Gotchas learned the hard way:

- **Non-ASCII can get mangled by automation bridges** (`·` → `Â·`, `é` → `Ã©`). Prefer ASCII text, or build special characters in-page (`String.fromCharCode(183)`). Verify char codes before saving.
- **Headline and About are rich-text (ProseMirror) contenteditables.** Fill with `el.focus(); document.execCommand('selectAll'); document.execCommand('delete'); document.execCommand('insertText', false, line)` and `insertParagraph` between lines. Don't insert empty paragraphs or you get double spacing.
- **Never press Escape inside an edit modal** — it opens a "discard changes?" prompt. If it appears, choose "No".
- **Skill typeaheads:** click "Add skill", focus the skill input, insert text, wait ~3 s, then select with `ArrowDown` × (index + 1) + `Enter` — mouse clicks on options are often swallowed. Check the picked name; the first suggestion is sometimes unrelated.
- **Limits:** 5 top skills, 5 skills per position/project, 5 Open-to-work titles. Job titles come from a fixed taxonomy — niche titles may not exist, pick the closest standard ones.
- **Native `<select>`s** (language proficiency, "Associated with"): set via the `HTMLSelectElement.prototype.value` setter and dispatch `change`.
- **Screenshot vs click coordinates:** check `innerWidth`/`devicePixelRatio`; some tools report a different page width than the CSS viewport.
- **Useful routes** (relative to `/in/<slug>/`): `edit/intro/` (headline), `edit/forms/summary/new/` (About + top skills), `edit/forms/project/new/`, `details/<section>/` (lists `edit/forms/<id>/` links per item), `details/languages/edit/forms/new/`. Open-to-work: the edit button on the profile's job-preferences card. Featured: a post's "…" menu → "Feature on top of profile".
- UI labels follow the account language; match buttons by role/aria-label in that language.
