# Clone Rebrand Checklist

Use this checklist when duplicating this project to create a different affiliate site from the same static-site engine, article workflow, and promotion workflow.

The goal is to preserve the parts that work:

- static source files in `src/`;
- generated output in `docs/`;
- roadmap-driven article creation;
- Amazon affiliate disclosure and product cards;
- Pinterest/Reddit promotion packs;
- simple GitHub Pages publishing.

And replace the parts that are brand- or niche-specific:

- site name, domain, analytics ID, affiliate tag if needed;
- homepage positioning;
- category structure;
- article formula;
- roadmap and long-tail targets;
- promo boards, pin copy, video hooks, and Reddit angles;
- visual assets and brand assets.

## Before Editing

Read these files first:

```text
README.md
CONTENT_ROADMAP.md
ARTICLE_CREATION_GUIDE.md
PROMOTION_WORKFLOW.md
src/KIT_PAGE_TEMPLATE.txt
scripts/build-site.js
scripts/build-promo-assets.ps1
package.json
```

Also inspect at least two finished article pages under `src/kits/` and one finished promo folder under `promo/`.

Do not edit `docs/` by hand. Edit source files and rebuild.

## Decide The New Site Brief

Write this before changing code:

- Site name.
- Domain.
- One-sentence promise.
- Target reader.
- Main problem categories.
- Product categories that can be monetized with Amazon links.
- Trust angle.
- Topics to avoid.
- Disclosure style.

Good affiliate site positioning should answer:

```text
When a visitor lands on this site, what specific buying mistake are we helping them avoid?
```

## Replace Brand Settings

Update:

- `package.json` name.
- `scripts/build-site.js` site object:
  - `name`
  - `baseUrl`
  - `customDomain`
  - `analyticsId`
  - `description`
- `docs/CNAME` indirectly by rebuilding after changing `customDomain`.
- Any visible brand text in `src/pages/`.
- Footer and disclosure wording if the new niche needs safer language.
- `assets/brand/` images and favicon files.
- Main hero image under `assets/images/`.

Search for old-brand terms:

```powershell
rg -n "Apartment Survival Kits|apartmentsurvivalkits|renter|rental|apartment|kits|renter-20" .
```

Only keep old terms if they truly belong to the new niche.

## Rebuild The Content Model

Update `CONTENT_ROADMAP.md` completely.

The roadmap should include:

- new positioning;
- core promise;
- public categories;
- current published pages;
- priority pages;
- category clusters;
- guides/trust pages;
- content selection rules;
- promotion notes.

Each planned article should include:

- status;
- category;
- page title;
- suggested URL;
- 3-5 long-tail targets;
- rough product types to recommend.

Prefer articles that meet at least four criteria:

- solves a concrete problem;
- has clear buyer intent;
- naturally supports 4-8 Amazon product links;
- has a "what to skip" or "what to avoid" section;
- can be promoted on Reddit without sounding like a listicle ad;
- can become 3 Pinterest pins;
- can internally link to at least 2 related pages.

## Update The Article Guide

Rewrite `ARTICLE_CREATION_GUIDE.md` for the new niche.

Keep the useful mechanics:

- source/output rules;
- metadata requirements;
- product cards;
- no manual Amazon prices, ratings, review counts, Prime status, or availability;
- FAQ and JSON-LD;
- internal links;
- build and verification steps.

Replace niche-specific rules:

- page formula;
- scoring fields;
- safety warnings;
- product selection rules;
- SEO patterns;
- trust differentiators;
- recommended next pages.

For compatibility, medical, safety, legal, or technical niches, add conservative language rules.

## Update The Static Generator

Edit `scripts/build-site.js`.

Replace:

- `site` object;
- `categories`;
- `guidePlans`;
- nav labels if needed;
- category page copy;
- all index page copy that assumes "kits" or "renters";
- CNAME/domain output.

Decide whether the URL structure should stay as `/kits/category/page/` or become something more natural, such as:

- `/problems/category/page/`
- `/guides/category/page/`
- `/fixes/category/page/`
- `/finders/category/page/`

If changing the top-level path, update:

- source metadata paths;
- category generation;
- homepage links;
- internal links;
- sitemap expectations;
- article guide examples;
- promo URL generation.

## Update Source Pages

Rewrite:

- `src/pages/index.html`
- `src/pages/about.html`
- `src/pages/contact.html`
- `src/pages/affiliate-disclosure.html`
- `src/pages/privacy.html` if domain/contact details change

Then decide whether to:

- remove old article pages and start fresh;
- keep a few as structural examples but unpublished;
- rewrite existing articles into new-niche articles.

If removing categories, also remove or rewrite their source folders under `src/kits/`.

## Update Templates

Rewrite `src/KIT_PAGE_TEMPLATE.txt`.

The template should match the new site vocabulary.

Examples:

- "Problem"
- "Best first buy"
- "What to check first"
- "Product shortlist"
- "What to skip"
- "Mistakes to avoid"
- "When not to buy"
- "FAQ"
- "On this page"

Avoid leaving old niche labels such as renter, deposit risk, no-drill, move-in, or kit unless they belong to the new site.

## Update Promotion Workflow

Rewrite `PROMOTION_WORKFLOW.md`.

Keep:

- 3 Pinterest pins per strong article;
- unique UTM links per pin;
- `PINTEREST_LEDGER.csv`;
- status values;
- Reddit manual/non-spam guidance;
- no direct Amazon links from pins.

Replace:

- recommended Pinterest boards;
- example URLs;
- disclosure copy;
- Reddit advice style;
- video hooks;
- Fiverr creative direction.

## Update Promo Asset Generator

Edit `scripts/build-promo-assets.ps1`.

This file is heavily niche-specific and must be reworked for every cloned site.

Replace:

- `$BaseUrl`;
- visible brand text in `Draw-Pin`;
- call-to-action text;
- logo initials;
- all entries in `$Articles`;
- Pinterest boards;
- keywords;
- video hooks;
- pin titles, subtitles, bullets, and descriptions;
- Fiverr brief style notes.

After the new site has fresh articles, update `$Articles` to match only published or soon-to-publish article slugs.

## Update Promo Files

For a clean new project, reset or regenerate:

```text
promo/PINTEREST_LEDGER.csv
promo/pinterest-upload-next.csv
promo/pinterest-upload-now.csv
promo/pinterest-upload-scheduled.csv
promo/pinterest-bulk-upload.csv
promo/<article-slug>/
```

Do not carry old Pinterest ledger rows into the new site unless intentionally preserving them for the same domain and articles.

## Update Assets And Visual Style

Replace:

- hero image;
- brand favicons;
- Pinterest profile image;
- any old-niche images.

Review `assets/style.css` for brand colors and old visual assumptions.

For a cloned site, keep the layout system but adjust:

- palette;
- hero image mood;
- icon/brand mark;
- category labels;
- card copy.

## Build And Verify

Run:

```powershell
npm run build
```

If local Node is unavailable, use the bundled Node runtime.

Verify:

```powershell
rg -n "Apartment Survival Kits|apartmentsurvivalkits|renter|rental|apartment|YOURTAG-20" .
rg -n "tag=" docs
Get-Content .\docs\sitemap.xml
Get-Content .\docs\robots.txt
```

Check:

- generated homepage exists at `docs/index.html`;
- generated category pages exist;
- sitemap contains the new domain;
- robots.txt points to the new sitemap;
- CNAME contains the new domain;
- Amazon links use the correct tag;
- old category names are gone;
- old promo URLs are gone;
- no links point to unpublished pages unless intentionally linking to hubs;
- product copy does not mention prices, ratings, review counts, Prime, or availability.

## Launch Order

Recommended launch sequence:

1. Rebrand site shell and generator.
2. Rewrite roadmap and article guide.
3. Publish 5-10 strong articles.
4. Generate promo packs for the strongest pages.
5. Rebuild and verify.
6. Push to GitHub Pages.
7. Upload first small Pinterest batch.
8. Track uploaded pins in `promo/PINTEREST_LEDGER.csv`.
9. Continue publishing articles from the roadmap.

## Handoff Prompt Template

Use this prompt in a fresh Codex session after duplicating the folder:

```text
This is a cloned affiliate static-site project. Do not assume the old niche is still correct.

First, read README.md, CLONE_REBRAND_CHECKLIST.md, CONTENT_ROADMAP.md, ARTICLE_CREATION_GUIDE.md, PROMOTION_WORKFLOW.md, src/KIT_PAGE_TEMPLATE.txt, scripts/build-site.js, scripts/build-promo-assets.ps1, and at least two existing article pages.

Then transform the project into a new affiliate site for:

[NEW SITE BRIEF HERE]

Preserve the static-site workflow:
- edit source files, not docs/ directly;
- keep roadmap-driven article creation;
- keep Amazon affiliate disclosure and product cards;
- keep Pinterest/Reddit promo workflow;
- rebuild with npm run build.

Update brand, homepage, categories, roadmap, article guide, template, generator, promo workflow, promo script, and source pages. Remove or rewrite old niche content. After changes, rebuild and verify that old brand/niche strings are gone.
```
