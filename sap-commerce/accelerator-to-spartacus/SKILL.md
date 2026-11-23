---
name: accelerator-to-spartacus
description: Inventory a SAP Commerce Accelerator (JSP/.tag) storefront and produce a migration checklist toward a headless Spartacus (Angular) storefront: custom pages, components, tags, CMS types, OCC endpoints needed, third-party integrations and risks. Use when scoping or starting an Accelerator-to-Spartacus project. Read-only.
argument-hint: "[path to the storefront extension] — optional; auto-detects"
disable-model-invocation: true
user-invocable: true
---

Scan the current repository (read-only) and report what a move to Spartacus involves. Use only what is in the repo and public SAP documentation. Do not run builds or imports. Never open `.env`, properties files with credentials, or data dumps.

## 1. Locate the storefront

Look for extensions with a `web/webroot/WEB-INF/views` folder, `web/webroot/WEB-INF/tags`, `acceleratoraddon` folders and `*-spring.xml` in the web layer. List them (name, role). If there are several storefronts (regions, brands), treat each separately.

## 2. Inventory (counts first, then the notable ones)

| Area | How to find it | Record |
| --- | --- | --- |
| **Pages** | `views/pages/**` JSPs and page controllers (`@Controller`, `@RequestMapping`) | Count; list the ones that are not standard accelerator pages |
| **CMS components** | `views/cms/**`, `*-items.xml` types extending `AbstractCMSComponent`, impex-seeded components | Count; each needs a Spartacus component mapping or an OOTB replacement |
| **Tags and fragments** | `WEB-INF/tags/**` | Count; map to Angular components or directives |
| **Addons** | `acceleratoraddon/**` | Per addon: purpose, replace with a Spartacus feature library, rebuild, or drop |
| **Custom controllers and form handling** | Controllers beyond the standard ones, custom `Form`/`Validator` classes | Each needs an OCC endpoint or a facade call |
| **Facades and populators used by the web layer** | Imports from controllers | Which ones the OCC API already exposes; which need a custom OCC endpoint |
| **JS/CSS** | `ACC.*` scripts, jQuery plugins, SCSS entry files, theme folders | Reuse of design tokens; scripts to port or drop |
| **i18n** | `*.properties` message bundles | Locale list; keys to move into Spartacus translation files |
| **Integrations** | Payment, tax, search, tracking, consent/GDPR, chat, A/B tests | Which have a Spartacus-compatible option |
| **Customizations of checkout and cart** | Checkout flow classes, step configs | Highest risk: list every deviation from the standard flow |
| **SEO and URLs** | URL patterns, `urlEncoder`, sitemap and robots, canonical rules | URL parity plan and redirect map; SSR needs |
| **Search** | Solr config, facet/sort customizations | Which need backend OCC changes |

## 3. Backend readiness

- Is `commercewebservices` (OCC) in the build? Which version?
- Which of the needed endpoints exist out of the box? Which would be custom?
- Is CORS, OAuth2 client setup and API-level caching in place or still to do?
- Is SmartEdit a requirement? Spartacus needs the SmartEdit integration.

## 4. Report

```
Storefronts found: <names>
Size: <N pages, N CMS components, N tags, N addons, N custom controllers>

Mapping
  Standard (Spartacus covers it): <list>
  Custom, port to Angular: <list, grouped by effort S/M/L>
  Custom, needs new OCC endpoint: <list>
  Drop or replace: <list, with reason>

Top risks (ordered): <checkout customizations, SEO/URL parity, SmartEdit, integrations...>
Suggested order: <skeleton + OOTB pages first, then custom components, then checkout, then integrations>
Unknowns to ask the team: <questions>
```

Estimate effort only as S/M/L per item and state the assumptions. Do not give calendar dates.
