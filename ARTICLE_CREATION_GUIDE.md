# Article Creation Guide

This is the operating manual for creating new Apartment Survival Kits pages.

If the chat history is unavailable, use this guide together with:

- `CONTENT_ROADMAP.md` - what pages to create.
- `src/KIT_PAGE_TEMPLATE.txt` - starter HTML structure.
- `scripts/build-site.js` - site generator.
- `README.md` - project/build overview.

## Project Positioning

Brand:

> Apartment Survival Kits

Core promise:

> Buy only what your rental actually needs.

Working description:

> Minimal, renter-safe kits for move-in, daily apartment problems, small spaces, no-drill fixes, and move-out.

Every page should feel like a practical renter decision tool, not a generic affiliate article.

## Affiliate Settings

Amazon Associates tag:

```text
renter-20
```

Use this tag in every Amazon product link:

```html
https://www.amazon.com/dp/ASIN/ref=nosim?tag=renter-20
```

Use this format for product images unless a better verified image URL is chosen:

```html
https://images-na.ssl-images-amazon.com/images/P/ASIN.01._SCLZZZZZZZ_.jpg
```

Product image cards should link to the Amazon product page:

```html
<a class="product-media" href="https://www.amazon.com/dp/ASIN/ref=nosim?tag=renter-20" rel="sponsored nofollow noopener" target="_blank">
  <img src="https://images-na.ssl-images-amazon.com/images/P/ASIN.01._SCLZZZZZZZ_.jpg" alt="Product name">
</a>
```

Do not manually state Amazon prices, ratings, review counts, Prime status, or availability in page copy. These change too often.

## Source And Output

Do not edit `docs/` by hand.

Edit source files:

```text
src/pages/
src/kits/
assets/
CONTENT_ROADMAP.md
ARTICLE_CREATION_GUIDE.md
```

Then rebuild:

```powershell
node .\scripts\build-site.js
```

If normal Node is unavailable in Codex, use the bundled Node runtime shown by the workspace dependency tool.

Generated output goes to:

```text
docs/
```

GitHub Pages publishes:

```text
main branch /docs folder
```

## Page Metadata

Every kit page source must start with metadata:

```html
<!--
title: Page Title | Apartment Survival Kits
description: Short SEO description.
path: /kits/category-slug/page-slug/
type: kit
category: category-slug
summary: One-sentence category card summary.
-->
```

Allowed category slugs:

```text
move-in
kitchen
cleaning
no-drill
small-space
daily-fixes
move-out
```

Guides use:

```text
type: guide
path: /guides/page-slug/
```

The builder automatically:

- wraps the body with shared head/header/footer;
- links CSS and JS;
- places the page in the correct category;
- updates category pages;
- updates `sitemap.xml`;
- copies assets into `docs/`.

## Page Structure

Use this structure for most kit pages:

1. Page hero
2. Scoreboard
3. Disclosure box
4. Quick verdict
5. Minimum kit / recommended kit
6. Product cards
7. Choosing table or scenario table
8. What to skip / what to avoid
9. Renter risk or move-out notes
10. Internal links
11. FAQ
12. JSON-LD FAQPage
13. Sidebar with "On this page"

The sidebar "On this page" is currently written manually inside each page. It is not generated automatically.

## Scores To Include

Use 4 scoreboard items. Choose the most relevant:

- `Buy priority`: Now / Before move-in / Later / Optional
- `Deposit risk`: 0/5 to 5/5
- `Space cost`: Low / Medium / High
- `Install effort`: None / 10 min / 30 min / Weekend
- `Tools`: None / Basic / Drill optional
- `Best for`: short use case

Use the scores to help renters decide, not as decoration.

## Product Selection Rules

Prefer products that are:

- useful for a concrete renter problem;
- broadly available on Amazon US;
- easy to explain without relying on price or reviews;
- compact enough for apartments;
- not overly specialized;
- compatible with move-in, no-drill, small-space, or move-out constraints.

Each product card should include:

- exact product title or clear product type;
- "for..." phrase in the heading;
- why it belongs in the kit;
- when to skip it;
- image link;
- Amazon button.

Example:

```html
<div class="product">
  <a class="product-media" href="https://www.amazon.com/dp/ASIN/ref=nosim?tag=renter-20" rel="sponsored nofollow noopener" target="_blank">
    <img src="https://images-na.ssl-images-amazon.com/images/P/ASIN.01._SCLZZZZZZZ_.jpg" alt="Product name">
  </a>
  <div>
    <h3>Product name <span>for renter use case</span></h3>
    <p>Explain why it belongs here. Include a skip-if warning where useful.</p>
    <a class="button amazon" href="https://www.amazon.com/dp/ASIN/ref=nosim?tag=renter-20">View on Amazon</a>
  </div>
</div>
```

Use 5-8 products for most kit pages. Fewer is better if the page is about a narrow problem.

## SEO Rules

Each page should target 3-5 long-tail phrases from `CONTENT_ROADMAP.md`.

Include them naturally in:

- `title`;
- `description`;
- H1 or intro;
- Quick verdict paragraph;
- FAQ questions;
- internal anchor text where relevant.

Avoid keyword stuffing. The page should read like useful advice.

Good patterns:

- "minimum [room] essentials for first apartment"
- "what [products] do I need for my first apartment"
- "renter friendly [solution] without drilling"
- "small apartment [problem] kit"
- "move out [problem] supplies apartment"

## Trust Differentiators

Every page should include at least one trust-building section:

- `What to skip until later`
- `What to avoid`
- `Renter risk notes`
- `Move-out notes`
- `Buy this only if...`
- `Skip this if...`

This is central to the site. Do not create pages that only list products.

## FAQ And Structured Data

Most full kit pages should include:

- visible FAQ section;
- matching `FAQPage` JSON-LD.

Keep FAQ answers short, practical, and consistent with page copy.

Do not make medical, legal, electrical, pest-control, security, or lease guarantees. Use careful language:

- "ask your landlord";
- "check your lease";
- "test a hidden spot";
- "report this to maintenance";
- "not a substitute for professional help."

## Internal Links

Each page should include 2-4 internal links to related categories or pages.

If a related page is not published yet, link to the category instead.

Examples:

```html
<div class="internal-links">
  <a href="../">Kitchen category</a>
  <a href="../../small-space/">Small-space category</a>
  <a href="../../move-in/">Move-in category</a>
</div>
```

## Images

Hero/category imagery:

- Use generated or original images when needed.
- Store project images in `assets/images/`.

Product images:

- Use Amazon image URL pattern by ASIN unless a product needs a different verified Amazon image URL.
- Do not download Amazon product images into the repository.
- If an image does not display after publishing, verify the ASIN and try a direct `m.media-amazon.com/images/I/...` URL from the product page.

## Research Workflow

Before writing a page:

1. Pick a `next` page from `CONTENT_ROADMAP.md`, or follow the user's requested topic.
2. Search the web for current products and ASINs.
3. Prefer primary/official sources where available, but ASIN lookups may come from product trackers, UPC databases, or retailer pages.
4. Do not rely on stale prices.
5. Choose products that fit the page's renter constraints.

## Build Workflow

After creating a page:

1. Save source file under the right folder, for example:

   ```text
   src/kits/kitchen/minimum-kitchen-kit.html
   ```

2. Update `CONTENT_ROADMAP.md` status from `next` or `planned` to `published`.
3. Rebuild:

   ```powershell
   node .\scripts\build-site.js
   ```

4. Verify:

   - generated page exists under `docs/`;
   - category page links to it;
   - `docs/sitemap.xml` includes it;
   - Amazon links include `tag=renter-20`;
   - no accidental non-ASCII characters;
   - no `YOURTAG-20`;
   - no links to unpublished pages unless intentionally linking to category hubs.

Useful checks:

```powershell
Select-String -Path .\docs\**\*.html -Pattern 'YOURTAG-20'
Select-String -Path .\docs\**\*.html -Pattern 'tag=renter-20'
Select-String -Path .\docs\sitemap.xml -Pattern 'page-slug'
```

## Current Published Kit Pages

- `/kits/kitchen/minimum-kitchen-kit/`
- `/kits/kitchen/no-pantry-organization/`
- `/kits/cleaning/first-apartment-cleaning-kit/`
- `/kits/move-in/basic-tool-kit/`
- `/kits/no-drill/no-drill-curtains/`
- `/kits/small-space/entryway-no-closet/`
- `/kits/daily-fixes/closet-smell-dampness/`
- `/kits/daily-fixes/dark-apartment-lighting/`

## Recommended Next Pages

Good candidates from the roadmap:

- `/kits/kitchen/tiny-counter-space/`
- `/kits/move-in/open-first-box/`
- `/kits/move-out/cleaning-kit/`
- `/kits/no-drill/cable-management/`
- `/kits/daily-fixes/door-security-no-drill/`

## Publishing

After rebuild:

```powershell
git add .
git commit -m "Add descriptive page name"
git push
```

GitHub Pages URL pattern:

```text
https://apartmentsurvivalkits.com/
```

Live published example:

```text
https://apartmentsurvivalkits.com/kits/kitchen/minimum-kitchen-kit/
```
